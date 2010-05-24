require "rubygems"
require "mongo_mapper"
require "jkl"

require "lib/models"
require "lib/politico"

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

task :cron do
  Politico::crawl
  puts "Cron Job - crawling - completed."
end

task :save_trend do
  Politico::crawl_trend("Roland Garros")
  puts "save completed."  
end
