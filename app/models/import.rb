class Import < CouchRest::Model::Base
  REGEXP_RULE = 'REGEXP_RULE'
  STRING_RULE = 'STRING_RULE'
  LUCKY_RULE = 'LUCKY_RULE'
  
  property :label,  String
  property :parser,  String
  property :rules, array: true do
    property :r_type, String
    property :token, String
    property :description, String
    property :account_in, String
    property :account_out, String
  end
  
  design do
    view :by_label
  end
end
