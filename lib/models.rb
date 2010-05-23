class Trend
  include MongoMapper::Document

  key :urls, Array
  key :name, String

  timestamps!

  many :clusters
end

class Cluster
  include MongoMapper::Document

  key :tags, Hash
  key :trend_id, ObjectId
  timestamps!

  validates_uniqueness_of :tags

  belongs_to :trend
end