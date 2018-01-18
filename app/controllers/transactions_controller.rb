class TransactionsController < ApplicationController
  def index
    @account = Account.find(params['account_id'])
    @transactions = if(@account.direction == Account::IN)
      Transaction.by_account_in_id(key: @account.id)
    else
      Transaction.by_account_out_id(key: @account.id)
    end
  end
  
  def new
    prepare_accounts
    @account = Account.find(params['account_id'])
    @transaction = Transaction.new
    if(@account.direction == Account::IN)
      @transaction.account_in = @account
    else
      @transaction.account_out = @account
    end
    @transaction.dt = Time.now.to_i
  end
  
  def create
    @transaction = Transaction.new
    @transaction.account_in = Account.find(params['account_in'])
    @transaction.account_out = Account.find(params['account_out'])
    @transaction.description = params['description']
    @transaction.amount = params['amount'].to_f
    @transaction.dt = params['dt'].to_i
    @transaction.save
    redirect_to accounts_path
  end
  
  def edit
  end
  
  private
  def prepare_accounts
    @accounts = {Account::IN => [], Account::OUT => []}
    Account.by_direction_and_label.all.each do |account|
      @accounts[account.direction] << account
    end
  end
end
