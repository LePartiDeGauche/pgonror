xml.instruct!
xml.rss("version" => "2.0") do
  xml.channel do
    xml.title current_page_title
    xml.subtitle current_page_description
    xml.link url_for accueil_rss_path(:only_path => false)
    xml.lastBuildDate Time.now.to_s(:rfc822)
    xml.language "fr-fr"
    xml.rights t('general.copyright')
    coder = HTMLEntities.new
    for article in @articles
      if article.category_option?(:controller) and
         article.category_option?(:action)
        xml.item do
          xml.pubDate article.published_at.to_s(:rfc822)
          xml.title coder.decode((article.heading.present? ? article.heading + " - " : "") + article.title)
          xml.guid article.uri
          if article.category_option?(:signature) and not article.signature.blank?
            xml.author do
              xml.name coder.decode(article.signature)
            end
          end
          xml.link url_for(:controller => article.category_option(:controller),
                           :action => article.category_option(:action), 
                           :uri => article.uri, 
                           :only_path => false)
          xml.description do
            if article.category_option?(:start_end_dates) or not article.agenda.blank?
              xml.cdata! article.start_end_datetime_display(true)
              if (article.category_option?(:address) or not article.agenda.blank?) and not article.address.blank?
                xml.cdata! article.address
              end
            end
            xml.cdata! article.content_only_with_inline unless article.content.blank?
          end
        end
      end
    end
  end
end