class Account < CouchRest::Model::Base
  IN = 'IN'
  OUT = 'OUT'

  property :label,     String
  property :direction, String

  collection_of :tags

  timestamps!

  design do
    view :by_code
    view :by_label
    view :by_direction
    view :by_direction_and_label
  end
end
