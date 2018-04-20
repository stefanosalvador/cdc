
class ParsersController < ApplicationController
  def new
    @imports = Import.all
  end
  
  def create
    prepare_accounts
    # - caricare dal db l'import corrispondente
    import = Import.find(params["import"])
    # preparare la classe per il parsing
    parser_file = "parser/#{import.parser.underscore}"
    require parser_file
    parser = parser_file.classify.constantize
    # passare il file al relativo parser
    @transactions = parser.parse(params['file'].open)
    @transactions.each do |transaction|
      # carica i dati in base alle regole
      import.rules.each do |rule|
        match_rule(rule, transaction)
        if(transaction[:matched])
          # cercare le eventuali transazioni già presenti: tocca usare un po' di euristica
          day = transaction[:dt] - transaction[:dt]%86400
          transaction[:found] = Transaction.by_account_to_id_and_dt.startkey( [transaction[:account_to], day]).endkey( [transaction[:account_to], day + 86400]).first
          # passiamo alla prossima
          break
        end
      end
    end
    # - preparare la pagina con la conferma delle transazioni
    # - l'immissione vera e propria delle transazioni avviene tramite il transactions_controller
  end
  
private

  def match_rule(rule, transaction)
    if(rule.r_type == Import::LUCKY_RULE)
      # cerca account from e to e aggiungi gli id alla transaction
      account_from = Account.by_label.key(transaction[:account_from]).first
      account_to = Account.by_label.key(transaction[:account_to]).first
      if(account_in && account_out)
        transaction[:matched] = true
        transaction[:description] = transaction[:imported_description]
        transaction[:imported_description] = ""
        transaction[:account_from] = account_from.id
        transaction[:account_to] = account_to.id
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
        transaction[:account_form] = rule.account_from
        transaction[:account_to] = rule.account_to
      end
    end
  end
end
