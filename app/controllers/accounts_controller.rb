class AccountsController < ApplicationController
  def index
    @accounts = Account.by_direction_and_label
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
    account.direction = params[:direction]
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
