class TransactionsController < ApplicationController
  def index
    @account = Account.find(params['account_id'])
    @transactions = Transaction.by_account_to_id_and_dt.startkey([@account.id, Time.local(2017,1,1).to_i]).endkey([@account.id, Time.now.to_i]).all
    if(@account.atype == Account::DEPOSIT)
      @transactions += Transaction.by_account_from_id_and_dt.startkey([@account.id, Time.local(2017,1,1).to_i]).endkey([@account.id, Time.now.to_i]).all
      @transactions.sort_by! {|t| t.dt}
    end
  end
  
  def new
    prepare_accounts
    @account = Account.find(params['account_id'])
    @transaction = Transaction.new
    @transaction.account_to = @account
    @transaction.dt = Time.now.to_i
  end
  
  def create
    @transaction = Transaction.new
    update_transaction
    respond_to do |format|
      format.html {redirect_to accounts_path}
      format.json { render json: {success: true, transaction_id: @transaction.id} }
    end
    
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

  def destroy
    @transaction = Transaction.find(params['id'])
    @transaction.destroy
    redirect_to accounts_path
  end

  private

  def update_transaction
    @transaction.account_from = Account.find(params['account_from'])
    @transaction.account_to = Account.find(params['account_to'])
    @transaction.description = params['description']
    @transaction.note = params['note']
    @transaction.amount = params['amount'].to_f
    @transaction.dt = params['dt'].to_i
    @transaction.save
  end
  
end
