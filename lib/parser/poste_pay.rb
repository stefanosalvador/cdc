module Parser
  class PostePay
    def self.parse(file, dt_import)
      transactions = []
      workbook = RubyXL::Parser.parse(file)
      worksheet=workbook.worksheets[0]
      worksheet.each do |row|
        next if row.nil? || row[2].nil? || row[2].value.nil? || ! row[2].value.is_a?(DateTime)
        dt = row[2].value.to_time.to_i
        description = row[5].value
        if(description =~ /([0-9]+{2})\/([0-9]+{2})\/([0-9]+{2}) ([0-9]+{2})\.([0-9]+{2})/)
		dt = Time.local($3.to_i, $2.to_i, $1.to_i, $4.to_i, $5.to_i).to_i
        end
        amount = (row[3].nil? || row[3].value.nil?) ? row[4].value.abs : row[3].value.abs
        next if(dt < dt_import)
        transactions << {
          imported_description: description,
          amount: amount,
          dt: dt
        }
      end
      return transactions
    end
  end
end 
