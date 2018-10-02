
class ParsersController < ApplicationController
  def new
    @imports = Import.all
  end
  
  def create
    prepare_accounts
    # caricare dal db l'import corrispondente
    import = Import.find(params["import"])
    # preparare la classe per il parsing
    parser_file = "parser/#{import.parser.underscore}"
    require parser_file
    parser = parser_file.classify.constantize
    dt_import = Time.parse(params['dt_import'])
    check_duplicates = params.has_key?('check_duplicates')
    # passare il file al relativo parser
    @transactions = parser.parse(params['file'].open, dt_import.to_i)
    @transactions.each do |transaction|
      # carica i dati in base alle regole
      import.rules.each do |rule|
        match_rule(rule, transaction)
        if(transaction[:matched])
          # passiamo alla prossima          
          break
        end
      end
      if(check_duplicates && transaction[:dt])
        # cercare le eventuali transazioni già presenti: per sicurezza prendiamo tutte quelle nello stesso giorno
        day = transaction[:dt] - transaction[:dt]%86400
        transaction[:found] = Transaction.by_dt.startkey(day).endkey(day + 86400)
      end
    end
    # preparare la pagina con la conferma delle transazioni
    # l'immissione vera e propria delle transazioni avviene tramite il transactions_controller
  end
  
private

  def match_rule(rule, transaction)
    if(rule.r_type == Import::LUCKY_RULE)
      # cerca account from e to e aggiungi gli id alla transaction
      transaction[:account_from] = accounts_hash[transaction[:account_from]]
      transaction[:account_to] = accounts_hash[transaction[:account_to]]
      if(transaction[:account_from] && transaction[:account_to])
        transaction[:matched] = true
        transaction[:description] = transaction[:imported_description]
        transaction[:imported_description] = ""
      end
    elsif(rule.r_type == Import::STRING_RULE)
      # controlla se la stringa è contenuta in imported_description
      return if transaction[:imported_description].nil?
      if(transaction[:imported_description].include?(rule.token))
        # aggiunti description, account from e to alla transaction
        transaction[:matched] = true
        transaction[:description] = rule.description
        transaction[:account_from] = rule.account_from
        transaction[:account_to] = rule.account_to
      end
    elsif(rule.r_type == Import::REGEXP_RULE)
      # controlla se la regexp maccia imported_description
      return if transaction[:imported_description].nil?
      if(transaction[:imported_description] =~ Regexp.new(rule.token))
        # aggiunti description, account from e to alla transaction
        transaction[:matched] = true
        transaction[:description] = rule.description
        transaction[:account_from] = rule.account_from
        transaction[:account_to] = rule.account_to
      end
    end
  end
  
  def accounts_hash
    @account_hash = Hash[Account.all.map{|a| [a.label, a.id]}] if(@account_hash.nil?)
    return @account_hash
  end
end
