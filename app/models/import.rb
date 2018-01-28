class Import < CouchRest::Model::Base
  property :label,  String
  property :parser,  String
  property :rules, Rule, array: true
end
