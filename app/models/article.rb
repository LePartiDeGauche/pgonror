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
class Article < ArticleBase
  # Default display of articles.
  def to_s
    title_display
  end
  
  # Heading of the article in a display mode.
  def heading_display
    self.heading.present? ? self.class.correct_french_typos(self.heading) : ""
  end

  # Title of the article in a display mode.
  def title_display
    self.title.present? ? self.class.correct_french_typos(self.title) : ""
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
   if self.parent_id.present? 
     folder = self.folder
     return folder.to_s if folder.present?
   end
   "-"   
  end

  # Returns the title of the source of information the article is attached to.  
  def source_display
   if self.source_id.present? 
     source = self.source
     return source.to_s if source.present?
   end
   "-"   
  end

  # Returns the title of the source of information the article is attached to.  
  def self.source_display(source_id)
   source_def = sources.find {|meaning, code| source_id == code}
   source_def.present? ? source_def[0] : "-"
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
    self.expired_at.to_date < Date.current + 1.month
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
    '</div>'
  end

  # Return a concatenated list of tags  
  def tags_display
    tags = ""
    self.tags.each { |tag| tags << tag.tag + " " }
    tags.strip
  end
  
  # Selects published article based on uri.  
  def self.find_published_by_uri(uri)
    where('uri = ? and status = ?', uri, ONLINE).first
  end

  # Selects published article based on id.  
  def self.find_published_by_id(id)
    where('id = ? and status = ?', id, ONLINE).first
  end

  # Calculates the number of pages to be displayed based on a number of articles.
  def self.calc_count_pages(count)
    (count / ARTICLES_PER_PAGE).ceil
  end

  # Selects articles based on various criteria.
  # See comments on method <tt>criteria</tt> for the details of the search options.  
  def self.find_by_criteria(options, page = 1, limit = ARTICLES_PER_PAGE)
    where(criteria(options)).
    offset((ARTICLES_PER_PAGE*(page-1)).to_i).
    limit(limit).
    order('published_at desc, updated_at desc')
  end
  
  def find_articles_by_parent(page = 1, limit = ARTICLES_PER_PAGE)
    self.class.find_by_criteria({:parent => self.id}, page, limit)    
  end

  def find_articles_by_source(page = 1, limit = ARTICLES_PER_PAGE)
    self.class.find_by_criteria({:source => self.id}, page, limit)    
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
  
  # Counts number of pages of articles to be displayed based on various criteria.  
  # See comments on method <tt>criteria</tt> for the details of the search options.  
  def self.count_pages_by_criteria(options)
    calc_count_pages count_by_criteria(options)
  end

  # Selects published articles associated to the parent article.  
  def find_published_by_folder(page = 1, limit = ARTICLES_PER_PAGE)
    self.class.find_by_criteria({:status => ONLINE, :parent => self.id}, page, limit)
  end

  # Selects randomly one published article associated to the parent article.  
  def find_published_by_folder_random
    count = self.class.count_by_criteria({:status => ONLINE, :parent => self.id})
    count > 0 ? 
      self.class.find_by_criteria({:status => ONLINE, :parent => self.id}).offset(rand(count).to_i).limit(1)[0] :
      nil
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

  # Selects published articles for a given category.  
  def self.find_published(category, page = 1, limit = ARTICLES_PER_PAGE)
    find_by_criteria({:status => ONLINE, :category => category}, page, limit)
  end

  # Selects all published articles.  
  def self.find_all_published(page = 1, limit = ARTICLES_PER_PAGE)
    find_by_criteria({:status => ONLINE, :searchable => true}, page, limit)
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
  
  # Selects published articles for the zoom.  
  def self.find_published_zoom(page = 1, limit = ARTICLES_PER_PAGE)
    find_by_criteria({:status => ONLINE, :zoom => true}, page, limit)
  end

  # Selects published articles for a given category.  
  def self.find_published_exclude_zoom(category, page = 1, limit = ARTICLES_PER_PAGE)
    find_by_criteria({:status => ONLINE, :category => category, :exclude_zoom => true}, page, limit)
  end

  # Searches published articles.  
  def self.search_published(search, page = 1, limit = ARTICLES_PER_PAGE)
    find_by_criteria({:status => ONLINE, :searchable => true, :search => search}, page, limit)
  end

  # Returns the number of pages to be displayed for published articles of a given category.
  def self.count_pages_published(category)
    calc_count_pages count_by_criteria({:status => ONLINE, :category => category})
  end
  
  # Returns the number of pages to be displayed for searched published articles.
  def self.count_pages_search_published(search)
    calc_count_pages count_by_criteria({:status => ONLINE, :searchable => true, :search => search})
  end

  def find_published_by_heading
    articles = []
    for article in self.class.find_by_criteria({:status => Article::ONLINE, :heading => self.heading}, 1, 5)
      articles << article if self.uri != article.uri
    end
    articles
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
  
  # Selects published articles for a given category grouped by heading.  
  def self.find_published_group_by_heading(category)
    select('heading').
    where(criteria({:status => ONLINE, :category => category})).
    where('heading is not null').
    group('heading').
    order('heading')
  end
  
private
 
  # Defines the SQL where clause for selecting articles based on various criteria.
  # - status: selects articles with a given status.
  # - category: selects articles with a given category.
  # - parent: selects articles with a given parent_id.
  # - source: selects articles with a given source_id.
  # - id: selects articles with a given id.
  # - searchable: selects articles with a 'searchable' category.
  # - feedable: selects articles without a 'unfeedable' category.
  # - access_level_reserved: selects articles with the 'reserved' access level.
  # - search: selects articles which contain a search string.
  # - any_date: selects articles whatever published_at and expired_at.
  # - zoom: selects articles with the zoom option set to true.
  # - exclude_zoom: selects articles with the zoom option set to false.
  # - heading: selects articles with a given heading.
  def self.criteria(options)
    "1=1" +
      (options[:any_date].present? ? "" : " and published_at <= #{quote(Date.current.to_s)}") +
      (options[:any_date].present? ? "" : " and expired_at >= #{quote(Date.current.to_s)}") +
      ((options[:status].present? and options[:status] == NEW) ? " and (status is null or status = '#{options[:status]}')" : "") +
      ((options[:status].present? and options[:status] != NEW and options[:status] != 'all') ? " and status = '#{options[:status]}'" : "") +
      (options[:category].present? ? " and category = '#{options[:category]}'" : "") +
      (options[:parent].present? ? " and parent_id = #{options[:parent]}" : "") +
      (options[:source].present? ? " and source_id = #{options[:source]}" : "") +
      (options[:id].present? ? " and id = #{options[:id]}" : "") +
      (options[:zoom].present? ? " and zoom = 't'" : "") +
      (options[:exclude_zoom].present? ? " and (zoom is null or zoom != 't')" : "") +
      (options[:searchable].present? ? " and category in (#{searchable_categories})" : "") +
      (options[:feedable].present? ? " and category in (#{feedable_categories})" : "") +
      (options[:access_level_reserved].present? ? " and category in (#{access_level_reserved_categories})" : "") +
      (options[:heading].present? ? " and heading = #{quote(options[:heading])}" : "") +
      (options[:search].present? ? 
          (" and (lower(title) like #{quote('%' + options[:search].downcase.strip + '%')}" + 
           " or lower(heading) like #{quote('%' + options[:search].downcase.strip + '%')}" +
           " or exists (select 1 from tags where article_id = articles.id and tag like #{quote('%' + options[:search].downcase.strip + '%')})" + 
           " or lower(address) like #{quote('%' + options[:search].downcase.strip + '%')}" + 
           " or lower(signature) like #{quote('%' + options[:search].downcase.strip + '%')})") : "")
  end
end