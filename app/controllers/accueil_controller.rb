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

# Controller for the web site home page.
class AccueilController < ApplicationController
  # Content of the home page
  def index
    @zooms = Article.find_published_zoom 1, 5
    @communiques = Article.find_published_exclude_zoom("('com','inter')", 1, 5)
    @dossier = Article.find_published_exclude_zoom 'dossier', 1, 1
    @actus = Article.find_published_exclude_zoom 'actu', 1, 2
    @vdg = Article.find_published_exclude_zoom 'articlevdg', 1, 1
    @ailleurs = Article.find_published_exclude_zoom 'web', 1, 1
    @livres = Article.find_published_exclude_zoom 'livre', 1, 3
    @arguments = Article.find_published_exclude_zoom 'argument', 1, 8
    @campagne = Article.find_published_exclude_zoom('campagne', 1, 1)[0]
    @directblogs = Article.find_published_exclude_zoom 'directblog', 1, 1
    @evenements = Article.find_published_order_by_start_datetime 'evenement', 1, 15
    @tracts = Article.find_published_militer 1, 1
    @videos = Article.find_published_home_video 1, 1
    @diapos = Article.find_published_exclude_zoom 'diaporama', 1, 1
  end

  # Global search functionality.
  def search
    @pages = Article.count_pages_search_published @search
    @articles = Article.search_published @search, @page
    unless @partial.nil?
      render :partial => 'layouts/articles_1col_2_on_3_search', :locals => { :articles => @articles, :partial => true }
      return
    end
    @side_articles = [
      Article.find_published('actu', 1, 1),
      Article.find_published('edito', 1, 1),
      Article.find_published('dossier', 1, 1),
      Article.find_published('com', 1, 1),
      Article.find_published('inter', 1, 1)
    ]
  end

  # Legal information page.
  def legal
    @legal = Article.find_published('legal', 1, 1)[0]
  end

  # Newspaper subscription.
  def agauche
    @presentation = Article.find_published('presentation_agauche', 1, 1)[0]
  end

  # Young network.
  def gavroche
    @presentation = Article.find_published('presentation_gavroche', 1, 1)[0]
  end

  # Home page for RSS flows.
  def accueil_rss
    @tags = ["Front de Gauche"]
  end

  # RSS output based on recent articles.
  def rss
    @articles = Article.find_by_criteria({:status => Article::ONLINE, :feedable => true, :search => @search}, 1, 40)
    if stale?(:etag => "rss" + (@search.nil? ? "" : @search), :last_modified => @articles[0].nil? ? nil : @articles[0].updated_at, :public => true)
      render :template => 'layouts/rss'
    end
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

  # Default action that shows a message due to an invalid route.
  def default
    id = params[:id]
    if id.present? and id.to_i > 0
      article = Article.find_published_by_id id
      if article.present? and article.path.present? and article.published?
        redirect_to article.path
        return
      end
    end
    log_warning "routing error"
    if params[:format].present? and ['jpg','jpeg','png','pdf','gif','doc','docx','txt','mp3','odt','zip'].include?(params[:format].downcase)
      render :nothing => true, :status => '404'
      return
    end
    render :template => '/layouts/not_found', :formats => :html, :status => '404'
  end
end