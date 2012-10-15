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

# Controller for the web site home page.
class AccueilController < ApplicationController
  caches_action :index, :layout => false
  caches_action :rss
  caches_action :sitemap
  caches_action :channel
  
  # Content of the home page
  def index
    @edito = Article.find_published_exclude_zoom 'edito', 1, 1
    @dossier = Article.find_published_exclude_zoom 'dossier', 1, 1
    @actus = Article.find_published_zoom 1, 5
    @communiques = Article.find_published_exclude_zoom 'com', 1, 8
    @inter = Article.find_published_exclude_zoom('inter', 1, 1)[0]
    @vdg = Article.find_published_exclude_zoom 'articlevdg', 1, 1
    @ailleurs = Article.find_published_exclude_zoom 'web', 1, 1
    @livres = Article.find_published_exclude_zoom 'livre', 1, 3
    @arguments = Article.find_published_exclude_zoom 'argument', 1, 5
    @campagne = Article.find_published_exclude_zoom('campagne', 1, 1)[0]
    @directblogs = Article.find_published_exclude_zoom 'directblog', 1, 1
    @evenements = Article.find_published_order_by_start_datetime 'evenement', 1, 15
    @tracts = Article.find_published_exclude_zoom 'tract', 1, 1
    @videos = Article.find_published_exclude_zoom 'video', 1, 1
    @diapos = Article.find_published_exclude_zoom 'diaporama', 1, 1
  end

  # Global search functionality.
  def search
    session[:search] = params[:search]
    @searched_articles = Article.search_published session[:search], @page
    @pages = Article.count_pages_search_published session[:search]
    @editos = Article.find_published 'edito', 1, 1
    @communiques = Article.find_published 'com', 1, 1
    @actus = Article.find_published 'actu', 1, 1
    @tout_international = Article.find_published 'inter', 1, 1
  end
  
  # Legal information page.
  def legal
    @legal = Article.find_published('legal', 1, 1)[0]
    @campagne = Article.find_published('campagne', 1, 1)[0]
  end
  
  # Newspaper subscription.
  def agauche
    @presentation = Article.find_published('presentation_agauche', 1, 1)[0]
  end
  
  # Young network.
  def gavroche
    @presentation = Article.find_published('presentation_gavroche', 1, 1)[0]
  end

  # RSS output based on recent articles.
  def rss
    @articles = Article.find_by_criteria({:status => Article::ONLINE, :feedable => true}, 1, 50)
    render :template => 'layouts/rss.xml'
  end

  # Renders most recent articles in a text format.  
  def export_txt
    file_path = "tmp/#{Date.current.strftime("%Y-%m-%d")}-lepartidegauche.txt"
    file = File.new(file_path, "w:utf-8")
    file.puts t('general.copyright') + " - " + I18n.l(Time.now, :format => :full) + "\r"
    for article in Article.find_by_criteria({:status => Article::ONLINE, :feedable => true}, 1, 50)
      if article.category_option?(:controller) and article.category_option?(:action)
        file.puts "\r"
        file.puts article.category_display.to_s + " : " + 
          ((article.heading.present? ? article.heading + " - " : "") + article.title) + "\r"
        file.puts "\r"
        file.puts I18n.l(article.published_at, :format => :long_ordinal) +
          ((article.category_option?(:signature) and not article.signature.blank?) ? ", " + article.signature : "") + "\r"
        file.puts "\r"
        break_line = false  
        unless article.content.blank?
          article.content_to_txt.each_line {|line|
            line.gsub!(/(\n|\r)/, "")            
            file.puts line + "\r" unless line.blank?
          }
        end
      end
    end
    file.close
    send_file file_path
  end
  
  # Site map used to inform search engines about pages.
  def sitemap
  end

  # The channel file addresses some issues 
  # with cross domain communication in certain browsers.
  # See http://developers.facebook.com/docs/reference/javascript/  
  def channel
    render :layout => false
  end

  # Default action that shows a message due to an invalid route.  
  def default
    id = params[:id]
    if id.to_i > 0
      article = Article.find_published_by_id id
      if article.present?
        redirect_to :controller => article.category_option(:controller),
                    :action => article.category_option(:action),
                    :uri => article.uri
        return
      end
    end
    log_warning "error: routing error"
    render :template => '/layouts/error.html.erb', :status => '404'
  end
end