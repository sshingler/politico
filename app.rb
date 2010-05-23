require "rubygems"
require "sinatra"
require "json"
require "haml"
require "mongo_mapper"
require "jkl"

require "lib/models"

config = {}
begin
  config = YAML::load_file('config/config.yml')
rescue Errno::ENOENT => e
end

mongo_host = ENV['MONGO_HOST'] || config['mongo-host']
mongo_db   = ENV['MONGO_DB']   || config['mongo-db'] 
mongo_user = ENV['MONGO_USER'] || config['mongo-user'] 
mongo_pass = ENV['MONGO_PASS'] || config['mongo-pass'] 

MongoMapper.connection = Mongo::Connection.new(mongo_host, 27017)
MongoMapper.database = mongo_db
MongoMapper.database.authenticate(mongo_user, mongo_pass)

key = ENV['CALAIS_KEY'] || YAML::load_file("config/keys.yml")["calais"]

get '/' do
  @trends = Trend.all(:created_at.gte => 24.hours.ago)
  haml :index
end

get '/:trend/cluster' do
  name = CGI::unescape(params[:trend])
  @trend = Trend.find_by_name(name)
  cluster = Cluster.find_by_trend_id(@trend.id)
  @tags = cluster.tags
  haml :cluster
end