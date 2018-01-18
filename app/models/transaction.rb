class Transaction < CouchRest::Model::Base
  property :description, String
  property :amount,      Float, :default => 0.0
  property :dt,          Integer, :default => Time.now.to_i
  property :note,        String

  belongs_to :account_in, class_name: 'Account'
  belongs_to :account_out, class_name: 'Account'

  design do
    view :by_account_in_id
    view :by_account_out_id
    view :amounts_by_account_in,
      :map =>
        "function(doc) {
          if ((doc['type'] == 'Transaction') && (doc['account_in_id'] != null )) {
            emit(doc['account_in_id'], -doc['amount']);
          }
        }",
      :reduce => "_sum"
    view :amounts_by_account_out,
      :map =>
        "function(doc) {
          if ((doc['type'] == 'Transaction') && (doc['account_out_id'] != null )) {
            emit(doc['account_out_id'], doc['amount']);
          }
        }",
      :reduce => "_sum"
    end
end
