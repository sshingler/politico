require "rubygems"
require "sinatra"
require "json"
require "haml"
require "mongo_mapper"
require "jkl"

require "lib/models"

get '/' do
  lab = Party.find_by_name("Labour")
  puts lab.clusters.class
  cluster = lab.clusters[lab.clusters.length-1]
  @tags = cluster.tags
  haml :index
end

get '/create' do
  Party.create({:name => "Labour", :url => "http://feeds.feedburner.com/LabourPartyNews?format=xml"}).save
  Party.create({:name => "Conservative", :url => "http://www.conservatives.com/XMLGateway/RSS/News.xml"}).save
  Party.create({:name => "LibDem", :url => "http://www.libdems.org.uk/latest_news.aspx?view=RSS"}).save
  Party.create({:name => "Green", :url => "http://www.greenparty.org.uk/news.rss"}).save
end