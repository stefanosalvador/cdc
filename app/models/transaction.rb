class Transaction < CouchRest::Model::Base
  property :description, String
  property :amount,      Float, :default => 0.0
  property :dt,          Integer, :default => Time.now.to_i
  property :note,        String

  belongs_to :account_from, class_name: 'Account'
  belongs_to :account_to, class_name: 'Account'

  design do
    view :by_dt
    view :by_account_from_id
    view :by_account_to_id
    view :by_account_to_id_and_dt
    view :by_account_from_id_and_dt
    view :by_amount
    view :amounts_by_account_from,
      :map =>
        "function(doc) {
          if ((doc['type'] == 'Transaction') && (doc['account_from_id'] != null )) {
            emit(doc['account_from_id'], -doc['amount']);
          }
        }",
      :reduce => "_sum"
    view :amounts_by_account_to,
      :map =>
        "function(doc) {
          if ((doc['type'] == 'Transaction') && (doc['account_to_id'] != null )) {
            emit(doc['account_to_id'], doc['amount']);
          }
        }",
      :reduce => "_sum"
    end
end
