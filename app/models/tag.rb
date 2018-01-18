class Tag < CouchRest::Model::Base
  property :name,        String

  timestamps!

  design do
    view :by_name
  end
end
