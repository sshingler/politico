require "rubygems"
require "sinatra"
require "json"
require "haml"
require "jkl"

get '/' do
  lab = "http://feeds.feedburner.com/LabourPartyNews?format=xml"
  con = "http://www.conservatives.com/XMLGateway/RSS/News.xml"
  lib = "http://www.libdems.org.uk/latest_news.aspx?view=RSS"
  green = "http://www.greenparty.org.uk/news.rss"

  feeds = [lab, con, lib, green]
  all_desc = []
  party_tags = []
  feeds.each do |feed|
    descriptions = Jkl::Rss::descriptions(Jkl::Rss::items(Jkl::get_xml_from(feed)))
    descriptions = descriptions.map do |description|
      Jkl::Text::strip_all_tags(description)
    end
    all_desc << descriptions
  end
  Jkl::Extraction::tags("pha8v7tap4zfxtmax3ry4nu9", all_desc[0]).inspect
  
end