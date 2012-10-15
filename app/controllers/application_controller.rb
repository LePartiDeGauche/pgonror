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
class ApplicationController < ActionController::Base
  helper :all
  protect_from_forgery
  layout "application"
  before_filter :page_number
  before_filter :page_title
  
protected

  # Sets variables used for pagination based on request parameters.
  def page_number
    @page = params[:page].present? ? params[:page].to_i : 1
    @pages = 1
    session[:search] = nil
    session[:category] = nil
    session[:parent] = nil
    session[:heading] = nil
    session[:source] = nil
  end
  
  # Sets a page title based on menus definition and article categories.
  def page_title
    menu = MENU.find {|meaning, options|
                                  options.present? and
                                  options[:controller].present? and
                                  options[:action].present? and 
                                  options[:controller].to_s == params[:controller] and
                                  options[:action].to_s == params[:action] 
    }
    if menu.present?
      @page_title = menu[0] 
      @page_description = menu[1][:description].blank? ? 
                                      menu[0] : 
                                      menu[1][:description] 
    else 
      category = CATEGORIES.find {|meaning, code, options|
                                    options.present? and
                                    options[:controller].present? and
                                    options[:action_all].present? and 
                                    options[:category_title].present? and 
                                    options[:controller].to_s == params[:controller] and
                                    options[:action_all].to_s == params[:action] 
      }
      @page_description = @page_title = category[2][:category_title] if category.present?
    end
  end
  
  # Selects information for the footer.
  def footer
    @footer_evenements = Article.find_published_order_by_start_datetime 'evenement', 1, 5
    @footer_videos = Article.find_published 'video', 1, 1
    @footer_diapos = Article.find_published 'diaporama', 1, 1
  end

  # Controls signed user is an administrator.
  def authenticate_administrator!
    @norobot = true
    if not user_signed_in? or not current_user.administrator
      flash[:notice] = t('passwd.no_auth')
      redirect_to :root
    end
  end

  # Controls signed user can publish information.
  def authenticate_publisher!
    @norobot = true
    if not user_signed_in? or not current_user.publisher
      flash[:notice] = t('passwd.no_auth')
      redirect_to :root
    end
  end

  # Controls signed user has access to reserved content.
  def authenticate_access_reserved!
    @norobot = true
    if not user_signed_in? or current_user.access_level != 'reserved'
      flash[:notice] = t('passwd.no_auth')
      redirect_to :root
    end
  end

  # Resets session backtrace information used for navigation.
  def reset_backtrace
    session[:breadcrumb_table] = nil
    session[:prior_url] = nil
  end

  # Pushes current url to the backtrace used for navigation.
  def save_backtrace
    session[:breadcrumb_table] = [] if session[:breadcrumb_table].nil?
    visited = { :url => request.url }
    session[:prior_url] = visited[:url]
    session[:last_url] = visited[:url]
    found = false
    breadcrumbs = []
    session[:breadcrumb_table].collect do |item|
     if request.url == item[:url]
        found = true
     elsif !found
        breadcrumbs << item
        session[:prior_url] = item[:url]
     end
    end
    breadcrumbs << visited
    session[:breadcrumb_table] = breadcrumbs
  end

  URL_HTTP = /(.+)%e2%80%99http(s?):\/(.*)%e2%80%99/
  # Selects one article based on its uri.
  def find_article
    if request.fullpath.downcase.match(URL_HTTP)
      uri = request.fullpath.downcase.gsub(URL_HTTP, "http\\2://\\3")
      redirect_to(URI.encode(uri.to_s))
    else
      @article = Article.find_published_by_uri params[:uri]
      if @article.nil?
        log_warning "find_article: not found"
        render :template => '/layouts/error.html.erb', :status => '404'
      else
        controller = @article.category_option(:controller)
        action = @article.category_option(:action)
        access_level = @article.category_option(:access_level)
        if controller.nil? or 
           action.nil? or 
           (access_level.present? and access_level == :reserved and current_user.access_level != "reserved") 
          log_warning "find_article: no access"
          render :template => '/layouts/error.html.erb', :status => '404'
        else
          @page_title = (@article.heading.present? ? @article.heading + " - " : "") + @article.title
          @page_keywords = ""
          @article.tags.each { |tag| @page_keywords << "," + tag.tag }
          @page_description = @article.description
          @source = (@article.present? and not @article.source_id.nil?) ? @article.source : nil
        end
      end
    end
  end
  
  # Logs a warning message.
  def log_warning(message, invalid = nil)
    logger.warn "[#{Time.now.strftime("%Y-%m-%d %H:%M:%S")}] WARNING #{message} #{invalid.present? ? invalid.message : ''} [#{request.url}] #{params.inspect}"
  end
  
  # Logs an error message.
  def log_error(message, invalid = nil)
    logger.error "[#{Time.now.strftime("%Y-%m-%d %H:%M:%S")}] ERROR #{message} #{invalid.present? ? invalid.message : ''} [#{request.url}] #{params.inspect}"
    alert_admins(message, invalid)
  end
  
  # Sens a notification to administrators.
  def alert_admins(message, invalid = nil)
    Notification.alert_admins(Devise.mailer_sender,
                              User.notification_recipients("administrator"), 
                              t('mailer.alert_admins') + " #{Time.now.strftime("%Y-%m-%d %H:%M:%S")}",
                              message + (invalid.present? ? " - " + invalid.message : ""),
                              request.url,
                              params.inspect,
                              invalid.present? ? invalid.backtrace : nil).deliver
  end
end