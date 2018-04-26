class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  def prepare_accounts
    @accounts = {Account::DEPOSIT => [], Account::EXPENSES => [], Account::INCOMES => []}
    Account.by_atype_and_label.all.each do |account|
      @accounts[account.atype] << account
    end
  end
end
