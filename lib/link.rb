class Link
# This class corresponds to a table in the database
# We can use it to manipulate the data

  # This makes the instances of this class Datamapper resources
  include DataMapper::Resource

  # This block describes what resources our model will have
  # Serial means auto-incremented for every record
  property :id    , Serial
  property :title , String
  property :url   , String

  has n, :tags, :through => Resource

end