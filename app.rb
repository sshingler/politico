require "rubygems"
require "sinatra"
require "json"
require "haml"
require "mongo_mapper"
require "jkl"

require "lib/models"

begin
  # Require the preresolved locked set of gems.
  require ::File.expand_path('../.bundle/environment', __FILE__)
rescue LoadError
  # Fallback on doing the resolve at runtime.
  require "rubygems"
  require "bundler"
  Bundler.setup
end

get '/' do
  @trends = Trend.all(:created_at.gte => 24.hours.ago)
  haml :index
end

get '/:trend/cluster' do
  key = ENV['CALAIS_KEY'] || YAML::load_file("config/keys.yml")["calais"]
  name = CGI::unescape(params[:trend])
  @trend = Trend.find_by_name(name)
  cluster = Cluster.find_by_trend_id(@trend.id)
  @tags = cluster.tags
  haml :cluster
end