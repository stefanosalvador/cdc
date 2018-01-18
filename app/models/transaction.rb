class Transaction < CouchRest::Model::Base
  property :description, String
  property :amount,      Float, :default => 0.0
  property :dt,          Integer, :default => Time.now.to_i

  belongs_to :account_in, class_name: 'Account'
  belongs_to :account_out, class_name: 'Account'

  design do
    view :by_account_in_id
    view :by_account_out_id
  end
end
