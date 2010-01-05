require "rubygems"
require "sinatra"
require "json"
require "haml"
require "mongo_mapper"
require "jkl"

require "lib/models"

get '/' do
  
end

get '/create' do
  Party.new({:name => "Labour", :url => "http://feeds.feedburner.com/LabourPartyNews?format=xml"}).save
  Party.new({:name => "Conservative", :url => "http://www.conservatives.com/XMLGateway/RSS/News.xml"}).save
  Party.new({:name => "LibDem", :url => "http://www.libdems.org.uk/latest_news.aspx?view=RSS"}).save
  Party.new({:name => "Green", :url => "http://www.greenparty.org.uk/news.rss"}).save
end