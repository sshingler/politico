require "rubygems"
require "sinatra"
require "json"
require "haml"
require "mongo_mapper"
require "jkl"

require "lib/models"
require "lib/politico"

begin
  # Require the preresolved locked set of gems.
  require ::File.expand_path('../.bundle/environment', __FILE__)
rescue LoadError
  # Fallback on doing the resolve at runtime.
  require "rubygems"
  require "bundler"
  Bundler.setup
end

KEY = ENV['CALAIS_KEY'] || YAML::load_file("config/keys.yml")["calais"]


enable :sessions

get '/categorize-your-website' do
  text = Jkl::Text::sanitize(Jkl::get_from("http://#{params[:url]}"), 1)
  @tags = Jkl::Extraction::tags(KEY, text)
  haml :tags
end

get '/' do
  @trends = Trend.all(:created_at.gte => 24.hours.ago)
  haml :index
end

get '/:trend/tags' do
  name = CGI::unescape(params[:trend])
  @trend = Trend.find_by_name(name)
  clusters = Cluster.find_all_by_trend_id(@trend.id)
  all_tags = clusters.map{|cluster| cluster.tags}
  @tags = {}
  all_tags.each_with_index do |t|
    @tags = @tags.keep_merge(t)
  end
  puts @tags.inspect
  haml :tags
end

post '/create' do
  Politico::crawl_trend(params[:trend])
  redirect "/"
end

get '/:trend/article' do
  name = CGI::unescape(params[:trend])
  @trend = Trend.find_by_name(name)
  # t, @text = Politico::add_urls(@trend)
  # puts "got these articles: #{@text}"
  # unless @text.empty?
  #   begin
  #     @tags = Jkl::Extraction::tags(@text.join(" ")[0..99999])
  #   rescue Calais::Error => ce
  #     puts ce.inspect
  #   end
  # end
  # haml :article
end