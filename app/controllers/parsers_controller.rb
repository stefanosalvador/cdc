require 'gnu_cash'
require 'bank1'
require 'bank2'
require 'poste_pay'

class ParsersController < ApplicationController
  def new
    @imports = Import.all
  end
  
  def create
    # - caricare dal db l'import corrispondente
    import = Import.find(params["import"])
    # preparare la classe per il parsing
    parser_file = "parser/#{import.parser}"
    require parser
    parser = parser_file.classify.constantize
    # passare il file al relativo parser
    transactions = parser.parse(params['file'])
    @proposed_transactions = []
    transactions.each do |transaction|
      # carica i dati in base alle regole
      import.rules.each do |rule|
        break if match_rule(rule, transaction)
      end
      @proposed_transactions << transaction
    end
    # - cercare le eventuali transazioni già presenti
    @proposed_transactions.each do |pt|
      # tocca usare un po' di euristica
    end
    # - preparare la pagina con la conferma delle transazioni
    # - l'immissione vera e propria delle transazioni avviene tramite il transactions_controller
  end
  
private

  def match_rule(rule, transaction)
    matched = false
    if(rule.r_type == Import::LUCKY_RULE)
      # cerca account in e out e aggiungi gli id alla transaction
    elsif(rule.r_type == Import::STRING_RULE)
      # controlla se la stringa è contenuta in imported_description
      # aggiunti description, account in e out alla transaction
    elsif(rule.r_type == Import::REGEXP_RULE)
      # controlla se la regexp maccia imported_description
      # aggiunti description, account in e out alla transaction
    end
    return matched
  end
end
