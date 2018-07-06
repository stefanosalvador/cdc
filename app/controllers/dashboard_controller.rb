class DashboardController < ApplicationController
  def index
    @last_transactions = Transaction.by_dt.limit(10).descending
    accounts = Transaction.by_account_to_id.reduce.group_level(1).rows
    @frequently_used_accounts = accounts.sort_by{|row| -row["value"]}[0..9].map{|row| Account.find(row["key"])}
  end
end
