# encoding: utf-8
# PGonror is the corporate web site framework of Le Parti de Gauche based on Ruby on Rails.
# 
# Copyright (C) 2013 Le Parti de Gauche
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
class Article < ActiveRecord::Base
  # Data updates before validation.
  before_validation :update_title, :update_uri, :update_content, :update_tags

  # Basic controls: mandatory attributes, uniqueness and formats.
  validates_presence_of :title, :category, :published_at, :expired_at, :updated_by
  validates :uri, :uniqueness => true
  validates :title, :format => {:with => /.*[^\.:-]$/}, :if => "title.present?"
  validates :heading, :format => {:with => /.*[^\.:-]$/}, :if => "heading.present?"
  validates :image_file_name, :format => {:with => /^([a-zA-Z0-9_-]+)\.(\w+)$/}, :if => "image_file_name.present?"
  validates :document_file_name, :format => {:with => /^([a-zA-Z0-9_-]+)\.(\w+)$/}, :if => "document_file_name.present?"

  # Associated articles using the 'parent' relationship.
  # This relationship is used in order to manage folders or repertories or articles,
  # so specific categories of articles refer to a 'parent' option.  
  belongs_to :folder, :class_name => 'Article', :foreign_key => :parent_id

  # Associated articles using the 'source' relationship.  
  # This relationship is used in order to manage several articles as source or information,
  # so specific categories of articles refer to a 'source' option.  
  belongs_to :source, :class_name => 'Article', :foreign_key => :source_id

  # Tags attached to the article.
  has_many :tags, :foreign_key => :article_id, :order => 'tag', :dependent => :destroy

  # Audit table.
  has_many :audits, :foreign_key => :article_id, :order => 'updated_at desc'

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
                  :original_url,
                  :zoom,
                  :zoom_video,
                  :home_video,
                  :zoom_sequence,
                  :gravity,
                  :agenda,
                  :legacy,
                  :image_remote_url_input,
                  :image,
                  :document,
                  :created_by,
                  :updated_by

  ## HTML coder used to tranform HTML special characters.
  @@coder = HTMLEntities.new

  # Sets geographical data based on the address.
  geocoded_by :address
  after_validation :geocode, :if => :address_changed?

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
                       :inline => { # Full display
                         :geometry => attachment.instance.reduce(LARGE_WIDTH),
                         :watermark_path => attachment.instance.watermark
                       },
                       :large => { # 2/3 layout
                         :geometry => attachment.instance.crop(LARGE_WIDTH,LARGE_HEIGHT),
                         :gravity => attachment.instance.gravity
                       },
                       :alternate => { # 1/2 layout
                         :geometry => attachment.instance.crop(ALTERNATE_WIDTH,ALTERNATE_HEIGHT),
                         :gravity => attachment.instance.gravity
                       },
                       :medium => { # 1/3 layout
                         :geometry => attachment.instance.crop(MEDIUM_WIDTH,MEDIUM_HEIGHT),
                         :gravity => attachment.instance.gravity
                       },
                       :small => { # 1/4 layout
                         :geometry => attachment.instance.crop(SMALL_WIDTH,SMALL_HEIGHT),
                         :gravity => attachment.instance.gravity
                       },
                       :mini => { # (2/3)/3 layout
                         :geometry => attachment.instance.crop(MINI_WIDTH,MINI_HEIGHT),
                         :gravity => attachment.instance.gravity
                       },
                       :zoom => { # Display in home page
                         :geometry => attachment.instance.crop(ZOOM_WIDTH,ZOOM_HEIGHT),
                         :gravity => attachment.instance.gravity
                       },
                      }
                    },
                    :path => ":rails_root/public/system/:attachment/:style/:uri",
                    :url => "/system/:attachment/:style/:uri",
                    :processors => [:Padder, :Watermark]

  # Reduces a thumbnail based on a maximum width, 
  # if the original width is greater than this maximum.
  def reduce(max_width)
    unless image.nil?
      file = image.to_file(:original)
      unless file.nil?
        geo = Paperclip::Geometry.from_file(file)
        geo.width > max_width ? "#{max_width}" : "#{geo.width}"
      end
    end
  end

  # Resizes a thumbnail based on its orientation. 
  # Landscape pictures are cropped to a maximum width and height.
  # Portrait pictures are reduced to a maximum width and height, pictures are centered.
  def crop(max_width, max_height)
    unless image.nil?
      file = image.to_file(:original)
      unless file.nil?
        geo = Paperclip::Geometry.from_file(file)
        geo.width > geo.height ? "#{max_width}x#{max_height}#" : "#{max_width}x#{max_height}>"
      end
    end
  end

  # Defines the watermark to be applied on thumbnails using PaperClip.
  def watermark
    not(self.signature.blank?) and self.signature.match(/photosdegauche.fr/) ?
      "#{Rails.root}/public/phototheque.png" : ""
  end

  # Controls on images: types and sizes.                       
  validates_attachment_content_type :image, :content_type=>['image/jpeg', 'image/png', 'image/gif']
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

  # Managed gravities.
  CENTER = "Center"
  SOUTH = "South"
  NORTH = "North"

  # List of managed gravities.
  GRAVITY = {
   CENTER => I18n.t('article.gravity.center'),
   SOUTH => I18n.t('article.gravity.south'),
   NORTH => I18n.t('article.gravity.north')
  }

  # List of categories (array) used in lists of values.
  def self.categories; CATEGORIES end

  # Returns the 'published' status of the article.
  def published?; self.status == ONLINE end

  # Returns the 'published' status of the article before latest change.
  def was_published?; self.status_was == ONLINE end

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

  # List of gravities(array) used in lists of values.
  def self.gravities
   [[I18n.t('article.gravity.center'), CENTER],
    [I18n.t('article.gravity.south'), SOUTH],
    [I18n.t('article.gravity.north'), NORTH]
   ]
  end

  # Returns the content of the article prepared for a specific display of images and videos.
  def content_with_inline; content_only_with("inline", INLINE_WIDTH, INLINE_HEIGHT) end
  def content_with_inline_small; content_only_with("inline", INLINE_WIDTH, INLINE_HEIGHT, MEDIUM_HEIGHT) end
  def content_with_large; content_with("large", LARGE_WIDTH, LARGE_HEIGHT, 2*LARGE_HEIGHT) end
  def content_with_medium; content_with("medium", MEDIUM_WIDTH, MEDIUM_HEIGHT) end
  def content_replaced_with_medium; content_replaced_with("medium", MEDIUM_WIDTH, MEDIUM_HEIGHT) end
  def content_with_small; content_with("small", SMALL_WIDTH, SMALL_HEIGHT) end
  def content_with_mini; content_with("mini", MINI_WIDTH, MINI_HEIGHT) end
  def content_with_alternate; content_with("alternate", ALTERNATE_WIDTH, ALTERNATE_HEIGHT) end
  def content_replaced_with_zoom; content_replaced_with("zoom", ZOOM_WIDTH, ZOOM_HEIGHT) end
  def extract_image_content; extract_image_content_with(available_content) end

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
  def self.pre_control_authorization(user_email, category, source = nil)
    ok = false
    authorization = User.get_authorization_article user_email, category, source
    ok = true if authorization.present?
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
    return "" if self.content.nil?
    @@coder.decode self.content
  end

  # Return a concatenated list of tags  
  def tags_display
    tags = ""
    self.tags.each{|tag| tags << (tags.blank? ? "" : ",") + tag.tag}
    tags
  end

  # Returns the content as a pure text string.
  def content_to_txt; convert_to_txt self.content end

  # Returns the title as a pure text string.
  def title_to_txt; convert_to_txt self.title end

  # Returns the address as a pure text string.
  def address_to_txt; convert_to_txt self.address end

  # Returns a description of the article.
  def description
    description = content_to_txt
    description = (description[0..150] + "…") if description.size > 150
    description << " [" + self.tags_display + "]" if not self.tags.empty?
    description.gsub(/\"/,"").strip
  end

  # Triggers an email notification of the creation or the update of the article.
  def email_notification(current_user_email = '', 
                         host = nil,
                         url = nil, 
                         published_url = nil, 
                         update = false,
                         comments = nil)
    recipients = Permission.notification_recipients(self.status, self.category, self.source_id)
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
                                       self.image_remote_url,
                                       self.show_heading,
                                       self.zoom_video,
                                       self.zoom_sequence,
                                       self.original_url,
                                       self.home_video,
                                       self.created_by,
                                       comments).deliver
    end
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
          open(URI.parse(url)) {|f|
            file_path = self.class.clean_uri(self.image_remote_url.gsub(/http(s?):(\/+)((www.)?)/,"")).gsub(/(\S+)-(jpg|jpeg|gif|png)/,"\\1.\\2")
            file_path = "tmp/#{file_path}"
            if "image/jpeg" == f.content_type and not file_path.match(/(\S+)(.jpg|.jpeg)/)
              file_path << ".jpeg"
            elsif "image/gif" == f.content_type and not file_path.match(/(\S+)(.gif)/)
              file_path << ".gif"
            elsif "image/png" == f.content_type and not file_path.match(/(\S+)(.png)/)
              file_path << ".png"
            end 
            file = File.new(file_path, "wb")
            file.write(f.read)
            file.close
            file = File.open(file_path)
            self.image = file
          }
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

  # Default display of articles.
  def to_s ; title_display ; end
  
  # Heading of the article in a display mode.
  def heading_display
    self.heading.present? ? self.class.correct_french_typos(self.heading).strip : ""
  end

  # Title of the article in a display mode.
  def title_display
    self.title.present? ? self.class.correct_french_typos(self.title).strip : ""
  end

  # Returns the title (displayed label) of a given article category.  
  def self.category_display(category)
    category_def = get_category_definition(category)
    category_def.present? ? category_def[0] : "-"
  end

  # Returns the title (displayed label) of the article category.
  def category_display
    self.class.category_display(self.category)
  end

  # Returns the title of the folder the article is attached to.  
  def folder_display
   if self.parent_id.present? and self.parent_id > 0 
     folder = self.folder
     return folder.to_s if folder.present?
   end
   ""
  end

  # Returns the title of the source of information the article is attached to.  
  def source_display
   if self.source_id.present? and self.source_id > 0
     source = self.source
     return source.to_s if source.present?
   end
   ""
  end

  # Returns the start and end date and time in a display mode.
  def start_end_datetime_display(full = false)
    display = start_datetime_display full
    end_display = end_time_display
    display = display + " à " + end_display if not end_display.blank?
    display.gsub(/ /, "&nbsp;").html_safe
  end

  # Returns the start date and time in a display mode.
  def start_datetime_display(full = false)
    return "" if self.start_datetime.nil?
    return I18n.l(self.start_datetime, :format => :date_only) if self.all_day
    I18n.l(self.start_datetime, :format => full ? :full : :default).gsub(/ /, "&nbsp;").html_safe
  end

  # Returns the end time in a display mode.
  def end_time_display
    return "" if self.end_datetime.nil? or self.no_endtime or self.all_day
    I18n.l(self.end_datetime, :format => :time_only).gsub(/ /, "&nbsp;").html_safe
  end

  # Indicates if an end time is present.
  def end_time?
    not(self.no_endtime) and not(self.all_day) and self.end_datetime.present?
  end
  
  # Indicates the article will expire in less than a month
  def will_expire_soon?
    self.expired_at.nil? ? false : self.expired_at.to_date < Date.current + 1.month
  end

  # Returns the status (displayed label) of the given status.  
  def self.status_display(status)
    STATUS.find {|code, meaning| (status.nil? ? NEW : status) == code}[1] 
  end

  # Returns the status (displayed label) of the article.  
  def status_display
    self.class.status_display self.status
  end

  # Returns the status of the article with style as an HTML string.  
  def status_display_with_style
    '<div class="' + 
    ((self.status.present? and self.status == ONLINE) ? 'online' : 'status') + '">' + 
    self.class.status_display(self.status) +
    (self.zoom ? " - #{I18n.t('activerecord.attributes.article.zoom')}" : "") +
    (self.zoom_video ? " - #{I18n.t('activerecord.attributes.article.zoom_video')}" : "") +
    '</div>'
  end

  # Returns the canonical path to the article.
  def path
    {:controller => self.category_option(:controller),
     :action => self.category_option(:action),
     :uri => self.uri}
  end

  # Returns the published date if it's in the future or the creation date.
  def published_datetime
    return self.published_at.to_datetime if self.published_at.to_datetime > self.created_at
    self.created_at
  end

  # Selects published article based on uri.  
  def self.find_published_by_uri(uri)
    where('uri = ? and status = ?', uri, ONLINE).first
  end

  # Selects published article based on id.  
  def self.find_published_by_id(id)
    where('id = ? and status = ?', id, ONLINE).first
  end

  # Selects articles based on various criteria.
  # See comments on method <tt>criteria</tt> for the details of the search options.  
  def self.find_by_criteria(options, page = 1, limit = ARTICLES_PER_PAGE)
    where(criteria(options)).
    offset((ARTICLES_PER_PAGE*(page-1)).to_i).
    limit(limit).
    order('published_at DESC, zoom_sequence ASC, updated_at DESC')
  end

  # Selects articles based on various criteria, order by updated date.
  # See comments on method <tt>criteria</tt> for the details of the search options.  
  def self.find_by_criteria_log(options, page = 1, limit = ARTICLES_PER_PAGE)
    where(criteria(options)).
    offset((ARTICLES_PER_PAGE*(page-1)).to_i).
    limit(limit).
    order('updated_at DESC')
  end

  def find_articles_by_parent(page = 1, limit = ARTICLES_PER_PAGE)
    self.class.find_by_criteria({:parent => self.id}, page, limit)
  end

  def find_articles_by_source(page = 1, limit = ARTICLES_PER_PAGE)
    self.class.find_by_criteria({:source => self.id}, page, limit)
  end

  # Counts number of pages of articles to be displayed based on various criteria.  
  # See comments on method <tt>criteria</tt> for the details of the search options.  
  def self.count_pages_by_criteria(options)
    calc_count_pages count_by_criteria(options)
  end

  # Selects published articles associated to the parent article.  
  def find_published_by_folder(page = 1, limit = ARTICLES_PER_PAGE)
    self.class.find_by_criteria({:status => ONLINE, :parent => self.id}, page, limit)
  end

  # Selects published articles associated to the parent article and given category.  
  def find_published_by_folder_and_category(category, page = 1, limit = ARTICLES_PER_PAGE)
    self.class.find_by_criteria({:status => ONLINE, :parent => self.id, :category => category}, page, limit)
  end

  # Selects randomly one published article associated to the parent article.  
  def find_published_by_folder_random(category)
    count = self.class.count_by_criteria({:status => ONLINE, :parent => self.id, :category => category})
    count > 0 ? 
      self.class.find_by_criteria({:status => ONLINE, :parent => self.id, :category => category}).
        offset(rand(count).to_i).limit(1)[0] : nil
  end

  # Returns the previous articles from the list of published articles.  
  def find_last_published
    articles = []
    for article in self.category_option?(:start_end_dates) ? 
                    self.class.find_published_order_by_start_datetime(self.category, 1, 5) :
                    self.class.find_published(self.category, 1, 5)
      articles << article if self.uri != article.uri
    end
    articles
  end

  # Returns published articles with the same heading.
  def find_published_by_heading
    articles = []
    for article in self.class.find_by_criteria({:status => Article::ONLINE, :searchable => true, :heading => self.heading}, 1, 5)
      articles << article if self.uri != article.uri
    end
    articles
  end

  # Selects published articles for a given category grouped by heading.  
  def self.find_published_group_by_heading(category)
    select('heading').
    where(criteria({:status => ONLINE, :category => category})).
    where('heading is not null').
    where('show_heading = ?', true).
    group('heading').
    order('heading')
  end

  # Selects published articles associated to a source of information.  
  def find_published_by_source(page = 1, limit = ARTICLES_PER_PAGE)
    self.class.find_by_criteria({:status => ONLINE, :source => self.id}, page, limit)
  end

  # Returns the number of pages to be displayed for published articles associated to a source of information.
  def count_pages_published_by_source
    self.class.calc_count_pages self.class.count_by_criteria({:status => ONLINE, :source => self.id})
  end

  # Selects categories and counts of articles for a given status.  
  def self.find_by_status_group_by_category(status, access_level = nil)
    if NEW == status
      categories = select("category, count(*) as count_category").
                   where('status is null or status = ?', status).
                   group('category')
    elsif access_level.present? and :reserved == access_level 
      categories = select("category, count(*) as count_category").
                   where("category in (#{access_level_reserved_categories})").
                   where('status = ?', status).
                   group('category')
    else
      categories = select("category, count(*) as count_category").
                   where('status = ?', status).
                   group('category')
    end
    display_categories = []
    for category in categories
      display_categories << [category.category, 
                             category.category_display, 
                             category.count_category]
    end
    display_categories.sort { |a,b| 
      a[1].downcase.gsub(/É/, "e").gsub(/À/, "a") <=> b[1].downcase.gsub(/É/, "e").gsub(/À/, "a") 
    }
  end

  # Counts articles with 'zoom' activated for a given status.  
  def self.count_by_status_zoom(status)
   if NEW == status
     where('status is null or status = ?', status).
     where('zoom = ?', true).
     count
   else
     where('status = ?', status).
     where('zoom = ?', true).
     count
   end
  end

  # Counts articles with 'zoom video' activated for a given status.  
  def self.count_by_status_zoom_video(status)
   if NEW == status
     where('status is null or status = ?', status).
     where('zoom_video = ?', true).
     count
   else
     where('status = ?', status).
     where('zoom_video = ?', true).
     count
   end
  end

  # Selects published articles for a given category.  
  def self.find_published(category, page = 1, limit = ARTICLES_PER_PAGE)
    find_by_criteria({:status => ONLINE, :category => category}, page, limit)
  end

  # Selects all published articles.  
  def self.find_all_published(page = 1, limit = ARTICLES_PER_PAGE)
    find_by_criteria({:status => ONLINE, :searchable => true}, page, limit)
  end

  # Selects published articles for a given category and heading.  
  def self.find_published_by_heading(category, heading, page = 1, limit = ARTICLES_PER_PAGE)
    find_by_criteria({:status => ONLINE, :category => category, :heading => heading}, page, limit)
  end

  # Selects published articles for a given category.  
  def self.find_published_order_by_title(category, page = 1, limit = ARTICLES_PER_PAGE)
    where(criteria({:status => ONLINE, :category => category})).
    offset((ARTICLES_PER_PAGE*(page-1)).to_i).
    limit(limit).order('title')
  end

  # Selects published articles for a given category.  
  def self.find_published_order_by_start_datetime(category, page = 1, limit = ARTICLES_PER_PAGE)
    where(criteria({:status => ONLINE, :category => category}) + ' or agenda = ?', true).
    where('start_datetime >= ?', Time.now - 4.hour).
    offset((ARTICLES_PER_PAGE*(page-1)).to_i).
    limit(limit).order('start_datetime')
  end

  # Returns the number of pages to be displayed for published articles of a given category.
  def self.count_pages_published_by_start_datetime(category)
    calc_count_pages count_by_criteria_by_start_datetime({:status => ONLINE, :category => category})
  end

  # Selects published articles for video categories.  
  def self.find_published_video(page = 1, limit = ARTICLES_PER_PAGE)
    find_by_criteria({:status => ONLINE, :video => true}, page, limit)
  end

  # Selects published articles for the zoom.  
  def self.find_published_zoom(page = 1, limit = ARTICLES_PER_PAGE)
    find_by_criteria({:status => ONLINE, :zoom => true}, page, limit)
  end

  # Selects published articles for the for videos to be displayed in the home page.  
  def self.find_published_home_video(page = 1, limit = ARTICLES_PER_PAGE)
    find_by_criteria({:status => ONLINE, :home_video => true}, page, limit)
  end

  # Selects published articles for the zoom for videos.  
  def self.find_published_zoom_video(page = 1, limit = ARTICLES_PER_PAGE)
    find_by_criteria({:status => ONLINE, :zoom_video => true}, page, limit)
  end

  # Selects published articles for a given category and excludes zoom.  
  def self.find_published_exclude_zoom(category, page = 1, limit = ARTICLES_PER_PAGE)
    find_by_criteria({:status => ONLINE, :category => category, :exclude_zoom => true}, page, limit)
  end

  # Selects published articles for a given category and excludes zoom for videos.  
  def self.find_published_exclude_zoom_video(category, page = 1, limit = ARTICLES_PER_PAGE)
    find_by_criteria({:status => ONLINE, :category => category, :exclude_zoom_video => true}, page, limit)
  end

  # Selects published video articles.  
  def self.find_published_video_exclude_zoom(page = 1, limit = ARTICLES_PER_PAGE)
    find_by_criteria({:status => ONLINE, :video => true, :exclude_zoom => true}, page, limit)
  end

  # Searches published articles.  
  def self.search_published(search, page = 1, limit = ARTICLES_PER_PAGE)
    find_by_criteria({:status => ONLINE, :searchable => true, :search => search}, page, limit)
  end

  # Returns the number of pages to be displayed for published articles of a given category.
  def self.count_pages_published(category)
    calc_count_pages count_by_criteria({:status => ONLINE, :category => category})
  end
  
  # Returns the number of pages to be displayed for published articles of a given category and heading.
  def self.count_pages_published_by_heading(category, heading)
    calc_count_pages count_by_criteria({:status => ONLINE, :category => category, :heading => heading})
  end

  # Returns the number of pages to be displayed for searched published articles.
  def self.count_pages_search_published(search)
    calc_count_pages count_by_criteria({:status => ONLINE, :searchable => true, :search => search})
  end

  # Returns the list of published articles that include an email address  
  def self.find_published_email_articles
    articles = []
    articles << ["« " + I18n.t('general.title') + " »", "X"]
    for category in CATEGORIES
      if category_option?(category[1], :email)
        for item in Article.find_published_order_by_title category[1], 1, 999
          articles << [item.title.html_safe, item.uri] if item.email.present?
        end
      end   
    end
    articles
  end

  # Selects all the available headings defined in articles.
  def self.all_headings(search)
    select('heading').
    where('heading is not null').
    where('lower(heading) like ?', search.nil? ? "%" : "%" + search.downcase.strip + "%").
    group('heading').
    order('heading').
    limit(25)
  end

  # Selects all the available signatures defined in articles.
  def self.all_signatures(search)
    select('signature').
    where('signature is not null').
    where('lower(signature) like ?', search.nil? ? "%" : "%" + search.downcase.strip + "%").
    group('signature').
    order('signature').
    limit(25)
  end

  # Selects all the available directories defined.
  def self.all_directories(search)
    select('title').
    where("category in #{where_clause_by_categories(:parent)}").
    where('lower(title) like ?', search.nil? ? "%" : "%" + search.downcase.strip + "%").
    group('title').
    order('title').
    limit(25)
  end

private

  # Returns a clean URI given as parameter.
  def self.clean_uri(uri)
    uri.downcase.
        gsub(/[ .'’\/]/,"-").
        gsub(/[àâäÀÂÄ]/,"a").
        gsub(/[éèêëÉÈÊË]/,"e").
        gsub(/[ìîïÌÎÏ]/,"i").
        gsub(/[òôöÒÔÖ]/,"o").
        gsub(/[ùûüÙÛÜ]/,"u").
        gsub(/[çÇ]/,"c").
        gsub(/[œŒ]/,"oe").
        gsub(/(-de-|-du-|-et-|-a-|-aux-|-l-)/, "-").
        gsub(/[^a-z0-9-]/,"").
        gsub(/-{2,}/,"-").
        gsub(/-\z/,"\\1")
  end

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
      self.title = self.class.clean_uri(self.image_remote_url.gsub(/http(s?):(\/+)((www.)?)/,""))
    elsif self.image_file_name.present? and self.title.blank?
      self.title = self.image_file_name
    elsif self.document_file_name.present? and self.title.blank?
      self.title = self.document_file_name
    end
    self.heading = self.folder_display if self.heading.blank? and self.parent_id.present?
  end

  # Updates article URI: makes the concatenation of parent or source title, if any, and the article title.
  def update_uri
    self.parent_id = nil if self.parent_id.present? and self.parent_id == 0 
    self.source_id = nil if self.source_id.present? and self.source_id == 0 
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

  # Updates tags: adds a new tag to the article when a default tag is found in the title, 
  # or the content of the article.
  # This way articles are tagged automatically by default with the predefined tags.
  def update_tags
    return if self.id.nil? or not(self.tags.empty?)
    for tag in unused_tags
      esc_tag = @@coder.encode(tag.tag, :named).downcase
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
    return extract.sub(ANY_IMAGE_EL, "<img src=\"\\2\" width=\"#{width}\" height=\"#{height}\">") if extract.present? 
    extract = source[DMOTION_TAG]
    return extract.sub(DMOTION_TAG, "<iframe src=\"http://www.dailymotion.com/embed/video/\\1?logo=0&hideInfos=1\" width=\"#{width}\" height=\"#{height}\"></iframe>") if extract.present? 
    extract = source[DAILYMOTION_OLD]
    return extract.sub(DAILYMOTION_OLD, "<iframe src=\"\\4?logo=0&hideInfos=1\" width=\"#{width}\" height=\"#{height}\"></iframe>") if extract.present? 
    extract = source[IFRAME_EL]
    return extract.sub(IFRAME_EL, "<iframe src=\"\\2?logo=0&hideInfos=1\" width=\"#{width}\" height=\"#{height}\"></iframe>") if extract.present? 
    source
  end

  # Returns a reference to an image hyperlink. 
  def extract_image_content_with(source)
    extract = source[ANY_IMAGE_EL]
    return extract.sub(ANY_IMAGE_EL, "\\2") if extract.present? 
    nil
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
    converted = source.gsub(DMOTION_TAG, "<iframe src=\"http://www.dailymotion.com/embed/video/\\1?logo=0&hideInfos=1\" width=\"#{width}\" height=\"#{videoheight}\"></iframe>").
                       gsub(DAILYMOTION_OLD, "<iframe src=\"\\4?logo=0&hideInfos=1\" width=\"#{width}\" height=\"#{videoheight}\"></iframe>").
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
    @@coder.decode source.gsub(/<\/p>/, "\n").gsub(/<br\s*\/>/,"\n").gsub(/<([^>]*)>/,"").strip
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

  # Returns the list of categories defined with the given option.
  def self.categories_with(option)
    searchable = ""
    for category in categories
      if category_option?(category[1], option) 
        searchable << "," unless searchable.blank? 
        searchable << "'#{category[1]}'"
      end   
    end
    searchable
  end

  # Returns the list of categories not defined with the given option.
  def self.categories_without(option)
    searchable = ""
    for category in categories
      if not category_option?(category[1], option)
        searchable << "," unless searchable.blank?
        searchable << "'#{category[1]}'"
      end
    end
    searchable
  end

  # Returns the list of categories with access_level = 'reserved'.
  def self.access_level_reserved_categories
    searchable = ""
    for category in categories
      if :reserved == category_option(category[1], :access_level)
        searchable << "," unless searchable.blank? 
        searchable << "'#{category[1]}'"
      end   
    end
    searchable
  end

  # Calculates the number of pages to be displayed based on a number of articles.
  def self.calc_count_pages(count)
    (count / ARTICLES_PER_PAGE).ceil
  end

  # Counts articles based on various criteria.  
  # See comments on method <tt>criteria</tt> for the details of the search options.  
  def self.count_by_criteria(options)
    where(criteria(options)).count
  end

  # Counts articles based on various criteria.  
  # See comments on method <tt>criteria</tt> for the details of the search options.  
  def self.count_by_criteria_by_start_datetime(options)
    where(criteria(options) + ' or agenda = ?', true).
    where('start_datetime >= ?', Time.now - 4.hour).
    count
  end

  # Defines the SQL where clause for selecting articles based on various criteria.
  # - status: selects articles with a given status.
  # - exclude_status: selects articles excluding given status.
  # - category: selects articles with a given category.
  # - parent: selects articles with a given parent_id.
  # - parent_search: selects articles with a given parent title or heading.
  # - source: selects articles with a given source_id.
  # - id: selects articles with a given id.
  # - video: selects articles with a 'video' category.
  # - searchable: selects articles with a 'searchable' category.
  # - feedable: selects articles without a 'unfeedable' category.
  # - access_level_reserved: selects articles with the 'reserved' access level.
  # - search: selects articles which contain a search string.
  # - any_date: selects articles whatever published_at and expired_at.
  # - zoom: selects articles with the zoom option set to true.
  # - zoom_video: selects articles with the zoom for videos option set to true.
  # - home_video: selects articles for videos on the home page option set to true.
  # - exclude_zoom: selects articles with the zoom option set to false.
  # - exclude_zoom_videos: selects articles with the zoom for videos option set to false.
  # - heading: selects articles with a given heading.
  def self.criteria(options)
    "1=1" +
      (options[:any_date].present? ? "" : " and published_at <= #{quote(Date.current.to_s)}") +
      (options[:any_date].present? ? "" : " and expired_at >= #{quote(Date.current.to_s)}") +
      ((options[:status].present? and options[:status] == NEW) ? " and (status is null or status = '#{options[:status]}')" : "") +
      ((options[:status].present? and options[:status] != NEW and options[:status] != 'all') ? " and status = '#{options[:status]}'" : "") +
      (options[:exclude_status].present? ? " and (status is null or status != '#{options[:exclude_status]}')" : "") +
      (options[:category].present? ? " and category = '#{options[:category]}'" : "") +
      (options[:parent].present? ? " and parent_id = #{options[:parent]}" : "") +
      (options[:source].present? ? " and source_id = #{options[:source]}" : "") +
      (options[:id].present? ? " and id = #{options[:id]}" : "") +
      (options[:zoom].present? ? " and zoom = 't'" : "") +
      (options[:zoom_video].present? ? " and zoom_video = 't'" : "") +
      (options[:home_video].present? ? " and home_video = 't'" : "") +
      (options[:exclude_zoom].present? ? " and (zoom is null or zoom != 't')" : "") +
      (options[:exclude_zoom_video].present? ? " and (zoom_video is null or zoom_video != 't')" : "") +
      (options[:video].present? ? " and category in (#{categories_with(:video)})" : "") +
      (options[:searchable].present? ? " and category in (#{categories_with(:searchable)})" : "") +
      (options[:feedable].present? ? " and category in (#{categories_without(:unfeedable)})" : "") +
      (options[:access_level_reserved].present? ? " and category in (#{access_level_reserved_categories})" : "") +
      (options[:heading].present? ? " and lower(heading) = #{quote(options[:heading].downcase.strip)}" : "") +
      (options[:parent_search].present? ?
        " and parent_id in (" +
        "select id from articles where " +
        "(lower(title) like #{quote('%' + options[:parent_search].downcase.strip + '%')} " +
        "or lower(heading) like #{quote('%' + options[:parent_search].downcase.strip + '%')}))" : "") +
      (options[:search].present? ?
        (" and (lower(title) like #{quote('%' + options[:search].downcase.strip + '%')}" + 
         " or lower(heading) like #{quote('%' + options[:search].downcase.strip + '%')}" +
         " or exists (select 1 from tags where article_id = articles.id and tag like #{quote('%' + options[:search].downcase.strip + '%')})" + 
         " or lower(address) like #{quote('%' + options[:search].downcase.strip + '%')}" + 
         " or lower(signature) like #{quote('%' + options[:search].downcase.strip + '%')})") : "")
  end
end