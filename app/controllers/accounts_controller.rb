class AccountsController < ApplicationController
  def index
    @accounts = Account.by_atype_and_label
    amounts_from = Hash[Transaction.amounts_by_account_from.reduce.group_level(1).rows.map{|a| a.values}]
    amounts_to = Hash[Transaction.amounts_by_account_to.reduce.group_level(1).rows.map{|a| a.values}]
    @amounts = amounts_from.merge(amounts_to){|key, fromval, toval| fromval + toval}
    @tags = Hash[Tag.all.map{|tag| [tag.id, tag.name]}]
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
