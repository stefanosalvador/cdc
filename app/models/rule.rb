class CatToy
  include CouchRest::Model::Embeddable

  property :token, String
  property :description, String
  property :account_in, String
  property :account_out, String
  
end 
