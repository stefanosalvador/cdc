class TransactionsController < ApplicationController
  def index
    @account = Account.find(params['account_id'])
    @transactions = Transaction.by_account_out_id(key: @account.id)
  end
  
  def new
    prepare_accounts
    @account = Account.find(params['account_id'])
    @transaction = Transaction.new
    @transaction.account_out = @account
    @transaction.dt = Time.now.to_i
  end
  
  def create
    @transaction = Transaction.new
    update_transaction
    redirect_to accounts_path
  end
  
  def edit
    prepare_accounts
    @transaction = Transaction.find(params['id'])
  end
 
  def update
    @transaction = Transaction.find(params['id'])
    update_transaction
    redirect_to accounts_path
  end
  
  private

  def update_transaction
    @transaction.account_in = Account.find(params['account_in'])
    @transaction.account_out = Account.find(params['account_out'])
    @transaction.description = params['description']
    @transaction.note = params['note']
    @transaction.amount = params['amount'].to_f
    @transaction.dt = params['dt'].to_i
    @transaction.save
  end
  
  def prepare_accounts
    @accounts = {Account::DEPOSIT => [], Account::EXPENSES => []}
    Account.by_atype_and_label.all.each do |account|
      @accounts[account.atype] << account
    end
  end
end
