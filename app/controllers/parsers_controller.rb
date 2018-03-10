
class ParsersController < ApplicationController
  def new
    @imports = Import.all
  end
  
  def create
    debugger
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
      # cerca account in e out e aggiungi gli id alla transaction
      account_in = Account.by_label.key(transaction[:account_in]).first
      account_out = Account.by_label.key(transaction[:account_out]).first
      if(account_in && account_out)
        transaction[:matched] = true
        transaction[:account_in] = account_in.id
        transaction[:account_out] = account_out.id
      end
    elsif(rule.r_type == Import::STRING_RULE)
      # controlla se la stringa è contenuta in imported_description
      return if transaction[:imported_description].nil?
      if(transaction[:imported_description].include?(rule.token))
        # aggiunti description, account in e out alla transaction
        transaction[:matched] = true
        transaction[:description] = rule.description
        transaction[:account_in] = rule.account_in
        transaction[:account_out] = rule.account_out
      end
    elsif(rule.r_type == Import::REGEXP_RULE)
      # controlla se la regexp maccia imported_description
      return if transaction[:imported_description].nil?
      if(transaction[:imported_description] =~ Regexp.new(rule.token))
        # aggiunti description, account in e out alla transaction
        transaction[:matched] = true
        transaction[:description] = rule.description
        transaction[:account_in] = rule.account_in
        transaction[:account_out] = rule.account_out
      end
    end
  end
end
