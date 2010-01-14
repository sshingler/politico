require "rubygems"
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

today = Time.now

task :cron do #=> :environment do
   puts "Updating clusters..."
   Party.all.each do |party|
     begin
       @items = Jkl::Rss::items(Jkl::get_xml_from(party.url))
       @items.map! do |i|
         pubDate = Date.parse(Jkl::Rss::attribute_from(i,"pubDate"))
         i if pubDate.day == today.day && pubDate.month == today.month && pubDate.year == today.year
       end
       @items.delete_if {|x| x == nil }
     rescue Errno::ETIMEDOUT
       puts "TODO error handle this"
     end
     descriptions = Jkl::Rss::descriptions @items
     descriptions.map! do |description|
       Jkl::Text::strip_all_tags(description)
     end
     key = ENV['CALAIS_KEY'] || YAML::load_file("config/keys.yml")["calais"]
     begin
     Cluster.create(
         {
           :tags => Jkl::Extraction::tags(key, descriptions.flatten),
           :party_id => party.id
         }
     ).save!
     rescue Exception
       puts "unable to create tags for the #{party.name} party on #{today.day}/#{today.month}"
     end
   end
   puts "done."
end
