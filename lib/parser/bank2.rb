class Parser::Bank2
  def self.parse(file)
    transactions = []
    workbook = RubyXL::Parser.parse(file)
    worksheet=workbook.worksheets[0]
    worksheet.each do |row|
      next if row.nil? || row[0].nil?
      dt = row[0].value
      next unless dt.is_a?(DateTime)
      transactions << {
        description: row[1].value,
        details: row[2].value,
        account: row[3].value,
        category: row[5].value,
        amount: row[7].value,
        dt: dt
      }
    end
    return transactions
  end
end
