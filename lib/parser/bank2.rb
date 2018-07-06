module Parser
  class Bank2
    def self.parse(file, dt_import)
      transactions = []
      workbook = RubyXL::Parser.parse(file)
      worksheet=workbook.worksheets[0]
      worksheet.each do |row|
        next if row.nil? || row[0].nil? || row[0].value.nil? || ! row[0].value.is_a?(DateTime)
        dt = row[0].value.to_time.to_i
        next if(dt < dt_import)
        transactions << {
          imported_description: "O{#{row[1].value}} D{#{row[2].value}} C{#{row[5].value}}",
          account_out: row[3].value,
          amount: row[7].value.abs,
          dt: dt
        }
      end
      return transactions
    end
  end
end
