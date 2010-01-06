class Party
  include MongoMapper::Document

  key :url, String
  key :name, String

  timestamps!

  validates_uniqueness_of :url

  many :clusters
end

class Cluster
  include MongoMapper::Document

  key :tags, Hash
  key :party_id, ObjectId
  timestamps!

  validates_uniqueness_of :tags

  belongs_to :party
end