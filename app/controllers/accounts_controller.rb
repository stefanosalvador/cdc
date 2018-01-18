class AccountsController < ApplicationController
  def index
    @accounts = Account.by_atype_and_label
    amounts_in = Hash[Transaction.amounts_by_account_in.reduce.group_level(1).rows.map{|a| a.values}]
    amounts_out = Hash[Transaction.amounts_by_account_out.reduce.group_level(1).rows.map{|a| a.values}]
    @amounts = amounts_in.merge(amounts_out){|key, inval, outval| inval + outval}
  end

  def edit
    @account = Account.find(params[:id])
  end

  def create
    account = Account.new
    save_account(account)
    redirect_to accounts_path
  end
  
  def update
    account = Account.find(params[:id])
    save_account(account)
    redirect_to accounts_path
  end
  
private

  def save_account(account)
    account.label = params[:label]
    account.atype = params[:atype]
    account.tags = []
    unless(params[:tags].nil? || params[:tags].empty?)
      params[:tags].each do |tag_id|
        account.tags << Tag.find(tag_id)
      end
    end
    unless(params[:new_tags].nil? || params[:new_tags].empty?)
      params[:new_tags].split(",").each do |name|
        account.tags << Tag.create(name: name.strip)
      end
    end
    account.save
  end
end
