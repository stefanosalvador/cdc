module Parser
  class GnuCash
    def self.parse(file)
      transactions = []
      
      file = File.open(file)  if(file.is_a?(String))
      doc = Nokogiri::XML(file)
      doc.remove_namespaces!

      accounts = {}
      doc.xpath("//book/account").each do |account|
        id = account.at_xpath("./id").text
        name = account.at_xpath("./name").text
        type = account.at_xpath("./type").text
        accounts[id] = {
          name: name,
          type: type
        }
      end

      doc.xpath("//book/transaction").each do |transaction|
        object = {}
        date = transaction.at_xpath("./date-posted/date").text
        object[:dt] = Time.parse(date).to_i
        object[:imported_description] = transaction.at_xpath("./description").text
        transaction.xpath("./splits/split").each do |split|
          v,d = split.at_xpath("./value").text.split("/").map{|s| s.to_f}
          value = v/d
          if(value > 0)
            account_in_id = split.at_xpath("./account").text
          else
            account_out_id = split.at_xpath("./account").text
          end
          object[:account_in] = accounts[account_in_id][:name]
          object[:account_out] = accounts[account_out_id][:name]
          object[:amount] = value
        end
        transactions << object
      end

      return transactions
    end
  end
end
