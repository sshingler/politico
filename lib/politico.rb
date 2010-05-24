require "cgi"
require "mongo_mapper"
require "jkl"

require "lib/models"

module Politico
  
  KEY = ENV['CALAIS_KEY'] || YAML::load_file("config/keys.yml")["calais"]
  
  class << self
    def crawl
      Jkl::trends.each do |trend|
        puts "got this trend #{trend}"
        crawl_trend(trend)
      end
    end
    
    def crawl_trend(name)
      trend = Trend.new({:name => name})
      Jkl::topix_links(CGI::escape(trend.name.gsub("#",""))).each do |url|
        trend.urls << url
        text = Jkl::Text::sanitize(Jkl::get_from(url), 12)
        begin
          next if text.empty?
          tags = Jkl::Extraction::tags(KEY, text)
          Cluster.create({:trend_id => trend.id, :tags => tags})
          trend.save
        rescue Calais::Error => ce
          puts ce.inspect
        end
      end
    end
  end
end