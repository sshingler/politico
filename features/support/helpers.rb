def new_party(name)
  Party.create(:name => name)
end

def new_feed(url)
  Feed.create(:url => url)
end

def new_post(title)
  Post.create(:title => title)
end

def new_tag(name)
  Tag.create(:name => name)
end

def new_category(name)
  Category.create(:name => name)
end