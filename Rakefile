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

key = ENV['CALAIS_KEY'] || YAML::load_file("config/keys.yml")["calais"]

task :cron do
  key = YAML::load_file('config/keys.yml')['calais']
  Politico::crawl(key)
  puts "Cron Job - crawling - completed."
end
