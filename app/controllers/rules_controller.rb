class RulesController < ApplicationController
  def index
    @import = Import.find(params['import_id'])
    @accounts = Hash[Account.all.map{|account| [account.id, account.label]}]
  end
  
  def new
    @import = Import.find(params['import_id'])
    @rule = {}
    @accounts = Account.by_atype_and_label
  end
  
  def create
    @import = Import.find(params['import_id'])
    @import.rules << {
      r_type: params["r_type"],
      token: params["token"],
      description: params["description"],
      account_in: params["account_in"],
      account_out: params["account_out"]
    }
    @import.save
    redirect_to import_rules_path(@import.id)
  end
  
  def edit
    @import = Import.find(params['import_id'])
    @rule = @import.rules[params['id'].to_i]
    @accounts = Account.by_atype_and_label
  end
  
  def update
    @import = Import.find(params['import_id'])
    rule = @import.rules[params['id'].to_i]
    rule.r_type = params["r_type"]
    rule.token = params["token"]
    rule.description = params["description"]
    rule.account_in = params["account_in"]
    rule.account_out = params["account_out"]
    @import.save
    redirect_to import_rules_path(@import.id)
  end
end
