class Account < CouchRest::Model::Base
  DEPOSIT = 'DEPOSIT'
  EXPENSES = 'EXPENSES'

  property :label,  String
  property :atype,  String

  collection_of :tags

  timestamps!

  design do
    view :by_code
    view :by_label
    view :by_atype
    view :by_atype_and_label
  end
end
