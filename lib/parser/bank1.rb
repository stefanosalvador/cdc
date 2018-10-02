module Parser
  class Bank1
    def self.parse(file, dt_import)
      transactions = []
      file = File.open(file) if(file.is_a?(String))
      file.each do |line|
        amount_pos = line =~ /(-{0,1}[0-9\.]+,[0-9]{2});EUR/
        next if amount_pos.nil?
        amount_raw = $1
        day, month, year = line[11..20].split('/')
        description = line[22..amount_pos-2]
        amount = amount_raw.gsub('.', '').gsub(',', '.').to_f
        if(description =~ /ore ([0-9]{2}):([0-9]{2})/ || description =~ /ORE ([0-9]{2}).([0-9]{2})/)
          hour = $1.to_i
          minutes = $2.to_i
        else
          hour = 0
          minutes = 0
        end
        dt = Time.local(year, month, day, hour, minutes).to_i
        next if(dt < dt_import)
        transactions << {
          imported_description: description,
          amount: amount.abs,
          dt: dt
        }
      end
      file.close
                              
      return transactions
    end
  end
end 
