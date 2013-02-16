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
class ApplicationController < ActionController::Base
  helper :all
  protect_from_forgery
  layout "application"
  around_filter :report_exceptions
  before_filter :page_number, :page_title

protected

  # Reports an exception to administrators.
  def report_exceptions
    begin
      yield
    rescue ArgumentError, EncodingError => invalid
      log_warning "ArgumentError", invalid
      @search = @page_heading = @category = @status = @parent = @source = ""
      @page =  @pages = 1
      render :template => '/layouts/not_found', :formats => :html, :status => '404'
      return 
    rescue Exception => invalid
      if Rails.env.production? or Rails.env.beta?
        log_error invalid.to_s, invalid
        render :template => '/layouts/error', :formats => :html, :status => '500'
        return 
      else
        raise invalid
      end
    end
  end

  # Sets variables used for pagination based on request parameters.
  def page_number
    @page = params[:page].present? ? params[:page].to_i : 1
    @pages = 1
    @page_heading = params[:heading].encode('utf-8', undef: :replace) unless params[:heading].nil?
    @search = params[:search].encode('utf-8', undef: :replace) unless params[:search].nil?
    @category = params[:category].encode('utf-8', undef: :replace) unless params[:category].nil?
    @status = params[:status].encode('utf-8', undef: :replace) unless params[:status].nil?
    @parent = params[:parent]
    @source = params[:source]
    @partial = params[:partial]
    @uri = params[:uri].encode('utf-8', undef: :replace) unless params[:uri].nil?
  end
  
  # Returns true when the cache mechanism can be activated.
  def can_cache?
    not(user_signed_in?) and
    params[:search].nil? and
    params[:category].nil? and
    params[:status].nil? and
    params[:page].nil? and
    params[:source].nil? and
    params[:parent].nil? and
    params[:heading].nil? and
    flash[:alert].nil? and
    flash[:notice].nil?
  end

  # Sets a page title based on menus definition and article categories.
  def page_title
    @og_type = "website"
    @hide_main_menu = false
    @identity_layout = "layouts/identity"
    @identity_icon = "PG-FDG.png";
    @root_path = url_for root_path(:only_path => false)
    menu = MENU.find {|meaning, options| options.present? and
                                         options[:controller].present? and
                                         options[:action].present? and 
                                         options[:controller].to_s == params[:controller] and
                                         options[:action].to_s == params[:action] 
    }
    if menu.present?
      @page_title = menu[1][:home].blank? ? menu[0] : ""
      @page_description = menu[1][:description].blank? ? menu[0] : menu[1][:description]
      @url = url_for(:controller => menu[1][:controller], :action => menu[1][:action])
      @hide_main_menu = menu[1][:hide_main_menu] == true if menu[1][:hide_main_menu].present?
      @identity_layout = menu[1][:identity_layout] if menu[1][:identity_layout].present?
      @identity_icon = menu[1][:identity_icon] if menu[1][:identity_icon].present?
    else 
      category = CATEGORIES.find {|meaning, code, options|
                                    options.present? and
                                    options[:controller].present? and
                                    options[:action_all].present? and 
                                    options[:category_title].present? and 
                                    options[:controller].to_s == params[:controller] and
                                    options[:action_all].to_s == params[:action] 
      }
      @page_title = category[2][:category_title] if category.present?
      @page_description = category[2][:description] if category.present?
      @url = url_for(:controller => category[2][:controller], :action => category[2][:action_all]) if category.present?
      header_menu = MENU.find {|meaning, options| options.present? and
                                                  options[:controller].present? and
                                                  options[:controller].to_s == params[:controller]
      }
      if header_menu.present?
        @header_name = header_menu[0]
        @header_link = url_for(:controller => header_menu[1][:controller], :action => header_menu[1][:action])
        @hide_main_menu = header_menu[1][:hide_main_menu] == true if header_menu[1][:hide_main_menu].present?
        @identity_layout = header_menu[1][:identity_layout] if header_menu[1][:identity_layout].present?
        @identity_icon = header_menu[1][:identity_icon] if header_menu[1][:identity_icon].present?
      end
    end
  end

  # Controls signed user is an administrator.
  def authenticate_administrator!
    @norobot = true
    if not user_signed_in? or not current_user.administrator
      flash[:alert] = t('passwd.no_auth')
      redirect_to :root
    end
  end

  # Controls signed user can publish information.
  def authenticate_publisher!
    @norobot = true
    if not user_signed_in? or not current_user.publisher
      flash[:alert] = t('passwd.no_auth')
      redirect_to :root
    end
  end

  # Controls signed user has access to reserved content.
  def authenticate_access_reserved!
    @norobot = true
    if not user_signed_in? or current_user.access_level != 'reserved'
      flash[:alert] = t('passwd.no_auth')
      redirect_to :root
    end
  end

  # Selects a list of articles based on a category.
  # The selection takes care of selected heading and page number.
  def find_list_articles_by_category(category)
    @category = category
    @pages = Article.count_pages_published_by_heading category, @page_heading
    @articles = Article.find_published_by_heading category, @page_heading, @page
    @headings = Article.find_published_group_by_heading category
    unless @partial.nil?
      render :partial => 'layouts/articles_1col_2_on_3', :locals => { :articles => @articles, :partial => true }
      return
    end
  end

  URL_HTTP = /(.+)%e2%80%99http(s?):\/(.*)%e2%80%99/
  # Selects one article based on its uri.
  def find_article
    if request.fullpath.downcase.match(URL_HTTP)
      uri = request.fullpath.downcase.gsub(URL_HTTP, "http\\2://\\3")
      redirect_to(URI.encode(uri.to_s))
    else
      @source = @last_published = @same_heading = @tags = nil
      @article = Article.find_published_by_uri @uri
      if @article.nil?
        log_warning "find_article: not found"
        render :template => '/layouts/not_found', :formats => :html, :status => '404'
      else
        controller = @article.category_option(:controller)
        action = @article.category_option(:action)
        access_level = @article.category_option(:access_level)
        if controller.nil? or 
           action.nil? or 
           (access_level.present? and access_level == :reserved and current_user.access_level != "reserved") 
          log_warning "find_article: no access"
          render :template => '/layouts/not_found', :formats => :html, :status => '404'
        else
          if not(can_cache?) or stale?(:etag => @article, :last_modified => @article.updated_at, :public => true)
            @page_title = ((@article.heading.present? ? @article.heading + " • " : "") + @article.title).gsub(/\"/, "").strip
            @page_description = @article.description
            @source = @article.source if @article.present? and not @article.source_id.nil?
            @last_published = @article.find_last_published if not @article.category_option?(:hide_category_name)
            @same_heading = @article.find_published_by_heading if not @article.heading.blank?
            @tags = @article.tags
            @url = url_for(:controller => controller, :action => action, :uri => @article.uri)
            @original_url = @article.original_url
            @og_type = "article"
            @og_type = "video.movie" if @article.category_option?(:video)
            @og_type = "music.song" if @article.category_option?(:audio)
            content = @article.extract_image_content
            @identity_icon = content unless content.nil?
            header_menu = MENU.find {|meaning, options| options.present? and
                                                      options[:controller].present? and
                                                      options[:controller].to_s == params[:controller]
            }
            if header_menu.present?
              @header_name = header_menu[0]
              @header_link = url_for(:controller => header_menu[1][:controller], :action => header_menu[1][:action])
              @hide_main_menu = header_menu[1][:hide_main_menu] == true if header_menu[1][:hide_main_menu].present?
              @identity_layout = header_menu[1][:identity_layout] if header_menu[1][:identity_layout].present?
            end
          end
        end
      end
    end
  end

  # Logs a warning message.
  def log_warning(message, invalid = nil)
    logger.warn "[#{Time.now.strftime("%Y-%m-%d %H:%M:%S")}] WARNING #{message} #{invalid.present? ? invalid.message : ''} [#{request.url}] from #{request.remote_ip} : #{params.inspect}"
  end

  # Logs an error message.
  def log_error(message, invalid = nil)
    logger.error "[#{Time.now.strftime("%Y-%m-%d %H:%M:%S")}] ERROR #{message} #{invalid.present? ? invalid.message : ''} [#{request.url}]  from #{request.remote_ip} : #{params.inspect}"
    alert_admins(message, invalid)
  end

  # Sens a notification to administrators.
  def alert_admins(message, invalid = nil)
    recipients = User.notification_recipients("notification_alert")
    Notification.alert_admins(Devise.mailer_sender,
                              recipients,
                              t('mailer.alert_admins') + " #{Time.now.strftime("%Y-%m-%d %H:%M:%S")}",
                              message + (invalid.present? ? " - " + invalid.message : ""),
                              request.url,
                              request.remote_ip,
                              params.inspect,
                              invalid.present? ? invalid.backtrace : nil).deliver unless recipients.empty?
  end
end