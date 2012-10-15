xml.instruct!
xml.urlset("xmlns" => "http://www.sitemaps.org/schemas/sitemap/0.9") do
  for menu in MENU
    menu = menu[1]
    xml.url do
      xml.loc url_for(:controller => menu, 
                      :only_path => false)
      xml.changefreq "daily"
      xml.priority 0.9
    end
  end
  for category in CATEGORIES
    category = category[1]
    if Article::category_option?(category, :controller) and
       Article::category_option?(category, :action_all) and
       Article::category_option?(category, :searchable)
      xml.url do
        xml.loc url_for(:controller => Article::category_option(category, :controller), 
                        :action => Article::category_option(category, :action_all),
                        :only_path => false)
        xml.changefreq "weekly"
        xml.priority 0.8
      end
      for article in Article.find_published(category, 1, 9999)
        xml.url do
          xml.loc url_for(:controller => article.category_option(:controller),
                          :action => article.category_option(:action), 
                          :uri => article.uri, 
                          :only_path => false)
          xml.lastmod article.published_at.to_s
          xml.changefreq "never"
          xml.priority 0.5
        end
      end
    end  
  end
end