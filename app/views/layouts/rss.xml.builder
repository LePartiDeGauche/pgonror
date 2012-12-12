coder = HTMLEntities.new
xml.instruct!
xml.rss("xmlns:itunes" => "http://www.itunes.com/dtds/podcast-1.0.dtd", "version" => "2.0") do
  xml.channel do
    xml.title coder.decode(current_page_title) + (session[:search].present? ? (" (" + session[:search] + ")") : "")
    xml.link url_for root_path(:only_path => false)
    xml.description coder.decode(current_page_description)
    xml.lastBuildDate Time.now.to_s(:rfc822)
    xml.language "fr-FR"
    xml.copyright t('general.copyright')
    xml.category "Politique"
    xml.image do
      xml.url root_url + "assets/PG.png"
      xml.title coder.decode(current_page_title)
      xml.link root_url
    end
    xml.tag! "itunes:author", t('general.title')
    xml.tag! "itunes:category", :text => "News &amp; Politics"
    xml.tag! "itunes:explicit", "clean"
    xml.tag! "itunes:isClosedCaptioned", "no"
    xml.tag! "itunes:summary", coder.decode(current_page_description)
    xml.tag! "itunes:image", root_url + "assets/PG500x500.jpg"
    xml.tag! "itunes:owner" do
      xml.tag! "itunes:name", t('general.copyright')
      xml.tag! "itunes:email", coder.decode(Devise.mailer_sender)
    end
    for article in @articles
      if article.category_option?(:controller)
        xml.item do
          xml.pubDate article.published_datetime.to_s(:rfc822)
          xml.title coder.decode((article.heading.present? ? article.heading + " • " : "") + article.title)
          xml.guid url_for(:controller => :accueil, 
                           :action => :default,
                           :id => article.id,
                           :only_path => false)
          if article.category_option?(:signature) and not article.signature.blank?
            xml.author do
              xml.name coder.decode(article.signature)
            end
          end
          xml.link article.category_option?(:action) ?
                    url_for(:controller => article.category_option(:controller),
                            :action => article.category_option(:action), 
                            :uri => article.uri, 
                            :only_path => false) :
                    url_for(:controller => article.category_option(:controller),
                            :only_path => false)
          xml.description do
            if article.category_option?(:start_end_dates) or not article.agenda.blank?
              xml.cdata! article.start_end_datetime_display(true)
              if (article.category_option?(:address) or not article.agenda.blank?) and not article.address.blank?
                xml.cdata! coder.decode(article.address)
              end
            end
            xml.cdata! article.content_with_inline unless article.content.blank?
          end
          if article.category_option?(:audio)
            duration = article.mp3_duration
            xml.tag! "itunes:author", coder.decode(article.signature)
            xml.tag! "itunes:explicit", "clean"
            xml.tag! "itunes:duration", duration
            xml.tag! "itunes:summary", coder.decode(article.content_to_txt)
            xml.tag! "itunes:keywords", coder.decode(article.tags_display)
            xml.enclosure(:url => root_url + article.document.url,
                          :type => article.document_content_type,
                          :length => article.document_file_size)
          end
        end
      end
    end
  end
end