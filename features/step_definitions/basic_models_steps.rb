Before do
  announce "before"
  Party.all.each{ |party| party.destroy}
  Cluster.all.each{|cluster| cluster.destroy}
  
  Party.create({:name => "Labour", :url => "http://feeds.feedburner.com/LabourPartyNews?format=xml"}).save
  Party.create({:name => "Conservative", :url => "http://www.conservatives.com/XMLGateway/RSS/News.xml"}).save
  Party.create({:name => "LibDem", :url => "http://www.libdems.org.uk/latest_news.aspx?view=RSS"}).save
  Party.create({:name => "Green", :url => "http://www.greenparty.org.uk/news.rss"}).save
end

When /^I request items for today$/ do
  @party = Party.all[rand(Party.all.size)]
  begin
    @items = Jkl::Rss::items(Jkl::get_xml_from(@party.url))
    @items.map! do |i|
      pubDate = Date.parse(Jkl::Rss::attribute_from(i,"pubDate"))
      t = Time.now
      i if pubDate.day == t.day && pubDate.month == t.month && pubDate.year == t.year
    end
    @items.delete_if {|x| x == nil }
  rescue Errno::ETIMEDOUT
    puts "TODO error handle this"
  end
end

Then /^I should add them to the database$/ do
  descriptions = Jkl::Rss::descriptions @items
  descriptions.map! do |description|
    Jkl::Text::strip_all_tags(description)
  end
  key = ENV['CALAIS_KEY'] || YAML::load_file("config/keys.yml")["calais"]
  Cluster.create(
      {
        :tags => Jkl::Extraction::tags(key, descriptions.flatten),
        :party_id => @party.id
      }
  ).save!
end

Then /^I should be able to read the tags back$/ do
  Cluster.all.should_not be_nil
end
