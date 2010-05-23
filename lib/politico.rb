require "cgi"
require "mongo_mapper"
require "jkl"

require "lib/models"

module Politico
  class << self
    def crawl(key)
      Jkl::trends.each do |trend|
        puts "got this trend #{trend}"
        t = Trend.new({:name => trend})
        t, articles = add_urls(t)
        puts "got these articles: #{articles}"
        next if articles.empty?
        puts "&&&&&&&&&&"
        puts "#{articles.join(" ").length}"
        begin
          tags = Jkl::Extraction::tags(key, articles.join(" ")[0..99999])
          Cluster.create({:trend_id => t.id, :tags => tags})
          t.save
        rescue Calais::Error => ce
          puts ce.inspect
        end
      end
    end
    
    def add_urls(trend)
      articles = []
      Jkl::topix_links(CGI::escape(trend.name.gsub("#",""))).each do |url|
        trend.urls << url
        articles << Jkl::Text::sanitize(Jkl::get_from(url))
      end
      [trend, articles]
    end
  end
end