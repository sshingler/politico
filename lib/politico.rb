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
        text = get_text_from(url)
        begin
          next if text.empty?
          extract_and_persist_tags(text)
        rescue Calais::Error => ce
          puts ce.inspect
        end
      end
    end
    
    def get_text_from(url)
      Jkl::Text::sanitize(Jkl::get_from(url), 12)
    end
    
    def extract_and_persist_tags(text)
      tags = Jkl::Extraction::tags(KEY, text)
      Cluster.create({:trend_id => trend.id, :tags => tags})
      trend.save
    end 
  end
end

class Hash #taken from http://www.ruby-forum.com/topic/142809
   def keep_merge(hash)
      target = dup
      hash.keys.each do |key|
         if hash[key].is_a? Hash and self[key].is_a? Hash
            target[key] = target[key].keep_merge(hash[key])
            next
         end
         target.update(hash) { |key, *values| values.flatten.uniq }
      end
      target
   end
end