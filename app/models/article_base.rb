# encoding: utf-8
# PGonror is the corporate web site framework of Le Parti de Gauche based on Ruby on Rails.
# 
# Copyright (C) 2012 Le Parti de Gauche
# 
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
# 
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
# 
# See doc/COPYRIGHT.rdoc for more details.

# Defines web site content using a generic class.
# Each article is defined with a title and a category.
# Content is managed through 1 'long text' attribute: content.
# Categories are defined using an internal array <tt>CATEGORIES</tt> setup in config/environment.rb.
# Several attributes are used based on options attached to each different category, 
# as documented into config/environment.rb.
# Articles are managed (added, updated or deleted) using the article controller,
# and they are visible into the web site using various controllers.
# Controllers, but also appropriate actions, are defined as options in the <tt>CATEGORIES</tt> setup.  
class ArticleBase < ActiveRecord::Base
  self.abstract_class = true

  # Data updates before validation.
  before_validation :update_title, :update_uri, :update_status, :update_content, :update_tags

  # Basic controls: mandatory attributes et uniqueness.
  validates_presence_of :title, :category, :published_at, :updated_by
  validates :uri, :uniqueness => true
  
  # Associated articles using the 'parent' relationship.
  # This relationship is used to order to manage folders or repertories or articles,
  # so specific categories of articles refer to a 'parent' option.  
  has_many :articles_by_parent, 
           :class_name => 'Article', 
           :foreign_key => :parent_id,
           :order => 'published_at desc, updated_at desc'
  belongs_to :folder, 
             :class_name => 'Article', 
             :foreign_key => :parent_id

  # Associated articles using the 'source' relationship.  
  # This relationship is used to order to manage several articles as source or information,
  # so specific categories of articles refer to a 'source' option.  
  has_many :articles_by_source, 
           :class_name => 'Article', 
           :foreign_key => :source_id,
           :order => 'published_at desc, updated_at desc'
  belongs_to :source, 
             :class_name => 'Article', 
             :foreign_key => :source_id

  # Tags attached to the article.
  has_many :tags,
           :foreign_key => :article_id, 
           :order => 'tag', 
           :dependent => :destroy

  # Audit table.
  has_many :audits, 
           :foreign_key => :article_id, 
           :order => 'updated_at desc'

  # Setup accessible (or protected) attributes for the model.
  attr_accessible :category,
                  :uri,
                  :published_at,
                  :expired_at,
                  :status, 
                  :draft,
                  :parent_id,
                  :source_id,
                  :heading,
                  :show_heading,
                  :title,
                  :signature, 
                  :content,
                  :start_datetime,
                  :end_datetime,
                  :no_endtime,
                  :all_day,
                  :address,
                  :email,
                  :external_id,
                  :zoom,
                  :agenda,
                  :legacy,
                  :image_remote_url_input,
                  :image,
                  :document,
                  :created_by,
                  :updated_by

  # Paperclip interpolation rule: used to include article uri in attachment paths.
  Paperclip.interpolates :uri do |attachment, style|
    attachment.instance.uri
  end

  # Thumbnail dimensions.
  INLINE_WIDTH = 612 ; INLINE_HEIGHT = 345
  LARGE_WIDTH = 612 ; LARGE_HEIGHT = 153
  ALTERNATE_WIDTH = 452 ; ALTERNATE_HEIGHT = 194
  MEDIUM_WIDTH = 292 ; MEDIUM_HEIGHT = 194
  SMALL_WIDTH = 212 ; SMALL_HEIGHT = 53
  MINI_WIDTH = 196 ; MINI_HEIGHT = 49
  ZOOM_WIDTH = 468 ; ZOOM_HEIGHT = 225

  # Attached images (using PaperClip).
  # The style 'inline' is considered as the default style used for the display
  # of articles in full format.
  # References to images are stored using the 'inline' style.
  has_attached_file :image, 
                    :styles => lambda { |attachment| { 
                       # Full display
                       :inline => {
                         :geometry => attachment.instance.reduce(LARGE_WIDTH),
                         :watermark_path => attachment.instance.watermark
                       },
                       :large => attachment.instance.crop(LARGE_WIDTH,LARGE_HEIGHT), # 2/3 layout 
                       :alternate => attachment.instance.crop(ALTERNATE_WIDTH,ALTERNATE_HEIGHT), # 1/2 layout
                       :medium => attachment.instance.crop(MEDIUM_WIDTH,MEDIUM_HEIGHT), # 1/3 layout
                       :small => attachment.instance.crop(SMALL_WIDTH,SMALL_HEIGHT), # 1/4 layout
                       :mini => attachment.instance.crop(MINI_WIDTH,MINI_HEIGHT), # (2/3)/3 layout
                       :zoom => attachment.instance.crop(ZOOM_WIDTH,ZOOM_HEIGHT) # Display in home page
                      } 
                    }, 
                    :path => ":rails_root/public/system/:attachment/:style/:uri",
                    :url => "/system/:attachment/:style/:uri",
                    :processors => [:Padder, :Watermark]

  # Reduces a thumbnail based on a maximum width, 
  # if the original width is greater than this maximum.
  def reduce(max_width)
     geo = Paperclip::Geometry.from_file(image.to_file(:original))
     geo.width > max_width ? "#{max_width}" : "#{geo.width}"
  end

  # Resizes a thumbnail based on its orientation. 
  # Landscape pictures are cropped to a maximum width and height.
  # Portrait pictures are reduced to a maximum width and height, pictures are centered.
  def crop(max_width, max_height)
     geo = Paperclip::Geometry.from_file(image.to_file(:original))
     geo.width > geo.height ? "#{max_width}x#{max_height}#" : "#{max_width}x#{max_height}>"
  end
  
  # Defines the watermark to be applied on thumbnails using PaperClip.
  def watermark()
    not(self.signature.blank?) and self.signature.match(/photosdegauche.fr/) ? 
      "#{Rails.root}/public/phototheque.png" : ""
  end
  
  # Controls on images: types and sizes.                       
  validates_attachment_content_type :image, :content_type=>['image/jpeg', 
                                                            'image/png', 
                                                            'image/gif']
  validates_attachment_size :image, options = {:less_than => 4.megabyte}

  # Attached images (using PaperClip).
  has_attached_file :document,
                    :path => ":rails_root/public/system/:attachment/:uri",
                    :url => "/system/:attachment/:uri"

  # Controls on documents: types and sizes.                       
  validates_attachment_size :document, options = {:less_than => 10.megabyte}

  # Number of articles to be displayed in a page.
  ARTICLES_PER_PAGE = 10.0

  # Managed statuses.
  REWORK = 'rework'
  NEW = 'new'
  REVIEWED = 'reviewed'
  ONLINE = 'on'
  OFFLINE = 'off'

  # List of managed statuses.
  STATUS = {
   NEW => I18n.t('article.status.new'),
   REWORK => I18n.t('article.status.rework'),
   REVIEWED => I18n.t('article.status.reviewed'),
   ONLINE => I18n.t('article.status.online'),
   OFFLINE => I18n.t('article.status.offline')
  }
  
  # List of categories (array) used in lists of values.
  def self.categories
    CATEGORIES
  end

  # Returns the 'published' status of the article.
  def published?
    self.status == ONLINE
  end

  # Returns the 'published' status of the article before latest change.
  def was_published?
    self.status_was == ONLINE
  end

  # List of articles (array) defined as folders used in lists of values.
  def self.folders
    array_of_articles_by_categories_by_parent self.
                                              where("category in #{where_clause_by_categories(:parent)}").
                                              order('category, title')
  end
  
  # List of articles (array) defined as sources of information used in lists of values.
  def self.sources
    array_of_articles_by_categories :source
  end
  
  # Returns the value of one option defined for a given article category.
  def self.category_option(category, option)
    category_def = get_category_definition(category)
    if category_def.present? and category_def[2].present?
      value = category_def[2][option]
      value.present? ? value : nil
    else
      nil
    end
  end

  # Returns the value of one option defined for the category of the article.
  def category_option(option)
    self.class.category_option(self.category, option)
  end

  # Returns the boolean value of one option defined for a given category of the article.
  def self.category_option?(category, option)
    category_def = get_category_definition(category)
    if category_def.present? and category_def[2].present?
      value = category_def[2][option]
      value.present? ? value : false
    else
      false
    end
  end

  # Returns the boolean value of one option defined for the category of the article.
  def category_option?(option)
    self.class.category_option?(self.category, option)
  end

  # List of statuses (array) used in lists of values.
  def self.statuses
   [[I18n.t('article.status.new'), NEW],
    [I18n.t('article.status.rework'), REWORK],
    [I18n.t('article.status.reviewed'), REVIEWED],
    [I18n.t('article.status.online'), ONLINE],
    [I18n.t('article.status.offline'), OFFLINE]
   ]
  end
  
  # Returns the content of the article prepared for a specific display of images and videos.
  def content_only_with_inline; content_only_with("inline", INLINE_WIDTH, INLINE_HEIGHT) end
  def content_with_large; content_with("large", LARGE_WIDTH, LARGE_HEIGHT, 2*LARGE_HEIGHT) end
  def content_with_medium; content_with("medium", MEDIUM_WIDTH, MEDIUM_HEIGHT) end
  def content_replaced_with_medium; content_replaced_with("medium", MEDIUM_WIDTH, MEDIUM_HEIGHT) end
  def content_with_small; content_with("small", SMALL_WIDTH, SMALL_HEIGHT) end
  def content_with_mini; content_with("mini", MINI_WIDTH, MINI_HEIGHT) end
  def content_with_alternate; content_with("alternate", ALTERNATE_WIDTH, ALTERNATE_HEIGHT) end
  def content_replaced_with_zoom; content_replaced_with("zoom", ZOOM_WIDTH, ZOOM_HEIGHT) end

  # Sets default values for the article.  
  def defaults(category = nil, parent = nil, source = nil)
    self.status = NEW
    self.published_at = Date.current
    self.expired_at = Date.current + 99.year
    self.category = category if category.present?
    self.parent_id = parent if parent.present?
    self.source_id = source if source.present?
  end
  
  # Creates an audit entry for the article (status).
  def create_audit!(status, updated_by, comments=nil)
    audits.create!(:status => status, :updated_by => updated_by, :comments => comments)
  end

  # Returns the list of categories that are activated for the given user.
  def self.activated_categories(user, source = nil)
    activated = []
    return activated if user.nil? or not user.publisher
    for permission in user.permissions.where("(source_id is null or source_id = ?) and authorization is not null and authorization  != ''", source)
      activated << [category_display(permission.category), permission.category] if permission.present?  
    end
    activated.sort { |a,b| 
      a[1].downcase.gsub(/É/, "e").gsub(/À/, "a") <=> b[1].downcase.gsub(/É/, "e").gsub(/À/, "a") 
    }
  end
  
  # Returns available tags, unused by any article.
  def unused_tags
    Tag.select("tag").
        where("article_id is null").
        where(self.id.present? ? 
                  "not exists (select 1 from tags tags2 where article_id = #{self.id} and tags2.tag = tags.tag)" : 
                  "").
        order('tag')    
  end

  # Updates article content: fixes typos and updates image and videos references for content.
  def update_content
    self.content = self.class.correct_french_typos(normalize_links self.content) if self.content.present?
    self.end_datetime = DateTime.new(self.start_datetime.year,
                                     self.start_datetime.month,
                                     self.start_datetime.mday,
                                     self.end_datetime.hour,
                                     self.end_datetime.min,
                                     self.end_datetime.sec,
                                     self.start_datetime.zone) if self.start_datetime.present? and self.end_datetime.present?
  end

  # Precontrols the level of authorization for the given user and category. 
  # The given user must be granted for the given category in order to get access to the action. 
  # This method is used by the article controller before the creation of an article. 
  def self.pre_control_authorization(user_email, category, source)
    ok = false
    authorization = User.get_authorization_article user_email, category, source
    ok = true if authorization.present?
    authorization_display = authorization.present? ? Permission::authorization_display(authorization) : I18n.t('general.unknown') 
    I18n.t('general.not_authorized_short') if not ok
  end

  # Controls the level of authorization of the article for the user who last updated the article.
  # The user who last updated the article must be granted for the article category 
  # and the appropriate status in order to confirm the update can be made. 
  # This method is used by the article controller during article creation or update.
  def control_authorization
    ok = false
    authorization = User.get_authorization_article self.updated_by, self.category, self.source_id
    if authorization.present?
      ok = true if (self.status.nil? or self.status == NEW or self.status == REWORK) and (authorization == Permission::EDITOR or authorization == Permission::REVIEWER or authorization == Permission::PUBLISHER)
      ok = true if (self.status == REVIEWED or self.status == OFFLINE) and (authorization == Permission::REVIEWER or authorization == Permission::PUBLISHER)
      ok = true if (self.status == ONLINE) and (authorization == Permission::PUBLISHER)
    end
    authorization_display = authorization.present? ? Permission::authorization_display(authorization) : I18n.t('general.unknown') 
    errors[:base] << I18n.t('general.not_authorized', 
                                  :authorization => authorization_display,
                                  :category => category_display,
                                  :source => source_display).html_safe if not ok
    ok
  end

  # Returns the content of the article.
  def available_content
    self.content.present? ? self.content : "" 
  end

  # Return a concatenated list of tags  
  def tags_display
    tags = ""
    self.tags.each{|tag| tags << (tags.blank? ? "" : ",") + tag.tag}
    tags
  end
  
  # Returns a description of the article.
  def description
    description = content_to_txt
    description = (description[0..150] + "…") if description.size > 150
    description << " [" + self.tags_display + "]" if not self.tags.empty?
    description
  end

  # Triggers an email notification of the creation or the update of the article.
  def email_notification(current_user_email = '', 
                         host = nil,
                         url = nil, 
                         published_url = nil, 
                         update = false,
                         comments = nil)
    recipients = Permission.notification_recipients(self.status, self.category, self.source_id)
    recipients << current_user_email if not recipients.include?(current_user_email)
    if not recipients.empty?
      Notification.notification_update(current_user_email, 
                                       recipients.join(', '),
                                       I18n.t(update ? 'mailer.notification_update_subject' : 'mailer.notification_create_subject'),
                                       self.heading,
                                       self.title,
                                       self.category_display,
                                       self.source_id.present? ? self.source_display : nil,
                                       self.parent_id.present? ? self.folder_display : nil,
                                       self.status_display,
                                       self.signature,
                                       url,
                                       published_url,
                                       self.tags_display,
                                       self.content.present? ? externalize_images(self.content, host) : nil,
                                       (category_option?(:image) and self.image_file_name.present?) ? host + self.image.url(:inline) : nil,
                                       self.published_at,
                                       self.will_expire_soon? ? self.expired_at : nil,
                                       self.zoom,
                                       self.created_by,
                                       comments).deliver
    end
  end
  
  # Returns the content as a pure text string.
  def content_to_txt
    convert_to_txt self.content
  end

  # Returns the attribute used in the form in order to copy an image from an external URL.
  def image_remote_url_input
    self.image_remote_url
  end
  
  # Sets the attribute used from the form in order to copy an image from an external URL.
  require 'open-uri'
  def image_remote_url_input=(url)
    if url != self.image_remote_url
      self.image_remote_url = url
      if not url.blank?
        begin
          self.image = open(URI.parse(url))
        rescue
          errors[:base] << I18n.t('activerecord.errors.messages.bad_image')
        end
      end
    end
  end

  # Returns the duration of associated mp3 file.
  def mp3_duration
    if self.category_option?(:audio) and 
       self.document_file_name.present? and
       self.document_file_name.match(/.mp3/i)
       return self.class.mp3_duration(self.document.path)
    end
    ""
  end

protected

  # Returns a clean URI given as parameter.
  def self.clean_uri(uri)
    uri.downcase.
        gsub(/[ .'’]/,"-").
        gsub(/[àâäÀÂÄ]/,"a").
        gsub(/[éèêëÉÈÊË]/,"e").
        gsub(/[ìîïÌÎÏ]/,"i").
        gsub(/[òôöÒÔÖ]/,"o").
        gsub(/[ùûüÙÛÜ]/,"u").
        gsub(/[çÇ]/,"c").
        gsub(/[œŒ]/,"oe").
        gsub(/(-de-|-du-|-et-|-a-|-aux-|-l-)/, "-").
        gsub(/[^a-z0-9-]/,"").
        gsub(/--/,"-").
        gsub(/--/,"-").
        gsub(/--/,"-").
        gsub(/-\z/,"\\1")
  end

private

  # Prepares SQL string against SQL injection.
  def self.quote(string)
    '\'' + string.gsub(/\\/, '\&\&').gsub(/'/, "''") + '\''
  end

  # Corrects typos in a given piece of text according the French practices (quotes, unbreakable spaces).
  def self.correct_french_typos(text)
    text.gsub("&laquo; ","&laquo;&nbsp;").gsub(" &raquo;","&nbsp;&raquo;").
         gsub("« ", "«&nbsp;").gsub(" »", "&nbsp;»").
         gsub(" :","&nbsp;:").gsub(" !","&nbsp;!").gsub(" ?","&nbsp;?").gsub("'","&rsquo;")
  end

  # Sets the article title as file name if the article is an image or a document.
  def update_title
    if self.image_remote_url.present? and not self.image_remote_url.blank? and self.title.blank?
      self.title = self.image_remote_url.split('/').last
    elsif self.image_file_name.present? and self.title.blank?
      self.title = self.image_file_name
    elsif self.document_file_name.present? and self.title.blank?
      self.title = self.document_file_name
    end
  end

  # Updates article URI: makes the concatenation of parent or source title, if any, and the article title.
  def update_uri
    if not self.legacy and not self.published?
      if self.image_file_name.present?
        if self.uri.blank?
          self.uri = self.parent_id.present? ? self.class.clean_uri(folder_display) + "-" : ""
          self.uri << image_file_name
        end
      elsif self.document_file_name.present?
        if self.uri.blank?
          self.uri = self.parent_id.present? ? self.class.clean_uri(folder_display) + "-" : ""
          self.uri << document_file_name
        end
      elsif self.title.present?
        self.uri = ""
        self.uri << self.class.clean_uri(self.heading) + "-" if not self.heading.blank? 
        self.uri << self.class.clean_uri(self.title)
        self.uri << "-" + self.id.to_s if self.id.present?
      end
    end
  end
  
  # Updates article status: sets default value if necessary.
  def update_status
    self.status = NEW if self.draft
  end
  
  # Updates tags: adds a new tag to the article when a default tag is found in the title, 
  # or the content of the article.
  # This way articles are tagged automatically by default with the predefined tags.
  def update_tags
    return if self.id.nil? or not(self.tags.empty?)
    coder = HTMLEntities.new
    for tag in unused_tags
      esc_tag = coder.encode(tag.tag, :named).downcase
      if (self.content.present? and self.content.downcase.include?(esc_tag)) or
         (self.title.present? and self.title.downcase.include?(tag.tag))
        if self.tags.where("tag = ?", tag.tag).first.nil?
          new_tag = self.tags.new
          new_tag.tag = tag.tag
          new_tag.created_by = self.updated_by
          new_tag.updated_by = self.updated_by
          new_tag.save!
        end
      end
    end
  end
  
  # Creates a tag in the list of tags proposed by default.
  def self.create_default_tag(tag, user_email)
    if Tag.select("tag").where("article_id is null").where("tag = ?", tag).first().nil?
      new_tag = Tag.new
      new_tag.tag = tag
      new_tag.created_by = user_email
      new_tag.updated_by = user_email
      new_tag.save!
    end
  end
  
  # Returns the definition (title, code and options) of a given article category.
  def self.get_category_definition(category)
    categories.find {|meaning, code| category == code}
  end

  # Returns the definition (title, code and options) of the article category.
  def get_category_definition
    self.class.get_category_definition(self.category.nil? ? NEW : self.category)
  end

  # Builds an array with articles for a given set of categories.
  def self.where_clause_by_categories(option)
    clause = "("
    first = true
    for category in self.categories
      if category[2].present?
        if category[2][option].present?
          if first
            first = false
          else
            clause << ","
          end
          clause << "'" + category[1] + "'"
        end
      end
    end
    clause << ")"
    clause
  end

  # Builds an array with articles for a given set of categories.
  def self.array_of_articles_by_categories(option)
    self.where("category in #{where_clause_by_categories(option)}").
    order('category, title').
    collect { |item| [("[" + item.category_display + "] " + item.title_display).html_safe, item.id]}
  end

  # Builds an array with articles for a given set of categories for a give parent.
  def self.array_of_articles_by_categories_by_parent(all_folders, parent_id = nil, level=0)
    articles = []
    sub_folfers = []
    all_folders.each do |item|
      sub_folfers << item if ((parent_id.nil? and item.parent_id.nil?) or (item.parent_id == parent_id))
    end
    sub_folfers.each do |item|
      articles << [ (("&nbsp;&nbsp;" * level) + "[" + item.category_display + "] " + item.title_display).html_safe, item.id ] 
      sub_articles = array_of_articles_by_categories_by_parent(all_folders, item.id, level+1)
      if not sub_articles.empty?
        for sub_item in sub_articles
          articles << sub_item 
        end
      end
    end
    articles
  end

  # Regular expressions used to transform references to images and videos.
  INTERNAL_IMAGE_EL = /<img(.*)src="(\S*)\/system\/images\/(large|medium|small|mini|inline|alternate|zoom)\/(\S+)(.jpg|.jpeg|.png|.gif)(\S*)"([^>]*)>/i
  INTERNAL_IMAGE_LINK_EL = /<a(.*)href="(\S*)\/system\/images\/(original|large|medium|small|mini|inline|alternate|zoom)\/(\S+)(.jpg|.jpeg|.png|.gif)(\S*)"([^>]*)>/i
  INTERNAL_DOCUMENT_LINK_EL = /<a(.*)href="(\S*)\/system\/documents\/(\S+)(.pdf|.doc|.docx|.odt|.zip|.txt|.mp3)(\S*)"([^>]*)>/i
  INTERNAL_AUDIO_LINK_EL = /<a(.*)href="(\S*)\/system\/documents\/(\S+)(.mp3)(\S*)"([^>]*)>/i
  ANY_IMAGE_EL = /<img(.*)src="(\S+)"([^>]*)>/i
  DMOTION_TAG = /\{dmotion\}(\S+)\{\/dmotion\}/i
  DAILYMOTION_OLD = /<object(.*)>(.*)<embed(.*)src="(\S+)"([^>]*)>(.*)<\/object>/i
  IFRAME_EL = /<iframe(.*)src="(\S+)"([^>]*)>([^<]*)<\/iframe>/i
  INLINE_REFERENCE_EL = /src=\"\/system\/([^\"]*)\"/i

  # Returns the content of the article with the reference of images or videos transformed with appropriate format.
  def content_with(target, width, height, videoheight=height)
    source = convert_content_with available_content, target, width, height, videoheight 
    source.gsub(ANY_IMAGE_EL, "<img src=\"\\2\">")
  end
  
  # Returns the content of the article with the reference of images or videos transformed with appropriate format.
  def content_only_with(target, width, height, videoheight=height)
    convert_content_with content, target, width, height, videoheight
  end

  # Returns a reference of an image or a video transformed with appropriate format found from the content of the article. 
  # When a reference if found, only the transformed reference (so an image or a video) is returned.
  # When no reference if found, the content is returned with no transformation.
  def content_replaced_with(target, width, height, videoheight=height)
    source = convert_content_with available_content, target, width, height, videoheight 
    extract = source[ANY_IMAGE_EL]
    return extract.gsub(ANY_IMAGE_EL, "<img src=\"\\2\" width=\"#{width}\" height=\"#{height}\">") if extract.present? 
    extract = source[DMOTION_TAG]
    return extract.gsub(DMOTION_TAG, "<iframe src=\"http://www.dailymotion.com/embed/video/\\1?logo=0&hideInfos=1\" width=\"#{width}\" height=\"#{height}\"></iframe>") if extract.present? 
    extract = source[DAILYMOTION_OLD]
    return extract.gsub(DAILYMOTION_OLD, "<iframe src=\"\\4?logo=0&hideInfos=1\" width=\"#{width}\" height=\"#{height}\"></iframe>") if extract.present? 
    extract = source[IFRAME_EL]
    return extract.gsub(IFRAME_EL, "<iframe src=\"\\2?logo=0&hideInfos=1\" width=\"#{width}\" height=\"#{height}\"></iframe>") if extract.present? 
    source
  end

  # Returns the content of the given source of text with the reference of images and documents transformed for storage.
  def normalize_links(source)
    source.present? ? 
      source.gsub(INTERNAL_IMAGE_EL, "<img\\1 src=\"/system/images/inline/\\4\\5\\6\"\\7>").
             gsub(INTERNAL_IMAGE_LINK_EL, "<a\\1 href=\"/system/images/\\3\/\\4\\5\\6\"\\7>").
             gsub(INTERNAL_DOCUMENT_LINK_EL, "<a\\1 href=\"/system/documents/\\3\\4\\5\"\\6>") :
    ""
  end

  # Returns the content of the given source of text with the reference of images transformed for the web, including host name.
  def externalize_images(source, host)
    source.present? ? source.gsub(INLINE_REFERENCE_EL, "src=\"#{host}system/\\1\"") : ""
  end

  # Returns the content of the given source or text with the reference of images or videos transformed with appropriate format.
  # No transformation is made of 'inline' format, which is format used for storage.
  def convert_content_with(source, target, width, height, videoheight=height)
    return "" if source.nil?
    converted = source.gsub(DMOTION_TAG, "<iframe src=\"http://www.dailymotion.com/embed/video/\\1?logo=0&hideInfos=1\" width=\"#{width}\" height=\"#{height}\"></iframe>").
                       gsub(DAILYMOTION_OLD, "<iframe src=\"\\4?logo=0&hideInfos=1\" width=\"#{width}\" height=\"#{height}\"></iframe>").
                       gsub(IFRAME_EL, "<iframe src=\"\\2?logo=0&hideInfos=1\" width=\"#{width}\" height=\"#{videoheight}\"></iframe>")
    converted = converted.gsub(INTERNAL_IMAGE_EL, "<img src=\"\\2/system/images/#{target}/\\4\\5\">") if target != "inline"
    converted = converted.gsub(INTERNAL_AUDIO_LINK_EL,
          "<br/>" +
          "<object type=\"application/x-shockwave-flash\" data=\"/swf/dewplayer.swf\" width=\"300\" height=\"20\" class=\"player-fallback\">" +
          "<param name=\"movie\" value=\"/swf/dewplayer.swf\" />" +
          "<param name=\"flashvars\" value=\"mp3=\\2/system/documents/\\3\\4\" />" +
          "<param name=\"wmode\" value=\"transparent\" />" +
          "</object>" +
          "<audio controls=\"controls\" src=\"\\2/system/documents/\\3\\4\" type=\"audio/mp3\">" +
          "</audio>" +
          "<br/>" +
          "<a\\1href=\"\\2/system/documents/\\3\\4\\5\"\\6>") if target == "inline"
    converted
  end
  
  # Returns the content into a pure text format.
  def convert_to_txt(source)
    return "" if source.blank?
    coder = HTMLEntities.new
    coder.decode source.gsub(/<\/p>/, "\n").gsub(/<br\s*\/>/,"\n").gsub(/<([^>]*)>/,"").strip
  end
  
  # Returns the duration of associated mp3 file.
  require "mp3info"
  def self.mp3_duration(source)
    if source.present?
      begin
        Mp3Info.open(source) do |mp3|
          return Time.at(mp3.length).utc.strftime("%H:%M:%S")
        end
      rescue
        return "?"
      end
    end
    ""
  end
end