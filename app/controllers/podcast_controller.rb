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

# Controller for the podcast.
class PodcastController < ApplicationController
  before_action :find_article, :only => [:son, :radioactu, :educpop, :radiomedia, :intervention]

  def index
  end

  def all
    find_list_articles_by_category "('son','radioactu','educpop','radiomedia','intervention')"
    return unless @partial.nil?
    @side_articles = [
      Article.find_published('radioactu', 1, 1),
      Article.find_published('educpop', 1, 1),
      Article.find_published('radiomedia', 1, 1),
      Article.find_published('intervention', 1, 1),
    ]
    @partial = false
    render :template => 'podcast/index'
  end

  def laradiodegauche
    @educpop = Article.find_published_exclude_zoom_video 'educpop', 1, 1
    @radioactu = Article.find_published_exclude_zoom_video 'radioactu', 1, 1
    @radiomedia = Article.find_published_exclude_zoom_video 'radiomedia', 1, 1
    @intervention = Article.find_published_exclude_zoom_video 'intervention', 1, 1
    if @educpop[0].present? and @radioactu[0].present? and @radiomedia[0].present? and @intervention[0].present?
      excludes = [ @educpop[0].id, @radioactu[0].id, @radiomedia[0].id, @intervention[0].id ].join(',')
      @side_articles = Article.find_published_audio_exclude_zoom(excludes, 1, 5)
    end
  end

  def educpop
    @side_articles = [
      Article.find_published('radioactu', 1, 1),
      Article.find_published('radiomedia', 1, 1),
      Article.find_published('intervention', 1, 1),
    ]
    render :template => 'layouts/article'
  end

  def educpopall
    find_list_articles_by_category 'educpop'
    return unless @partial.nil?
    @side_articles = [
      Article.find_published('radioactu', 1, 1),
      Article.find_published('radiomedia', 1, 1),
      Article.find_published('intervention', 1, 1),
    ]
    render :template => 'layouts/index'
  end

  def radioactu
    @side_articles = [
      Article.find_published('educpop', 1, 1),
      Article.find_published('radiomedia', 1, 1),
      Article.find_published('intervention', 1, 1),
    ]
    render :template => 'layouts/article'
  end

  def radioactuall
    find_list_articles_by_category 'radioactu'
    return unless @partial.nil?
    @side_articles = [
      Article.find_published('educpop', 1, 1),
      Article.find_published('radiomedia', 1, 1),
      Article.find_published('intervention', 1, 1),
    ]
    render :template => 'layouts/index'
  end

  def radiomedia
    @side_articles = [
      Article.find_published('radioactu', 1, 1),
      Article.find_published('educpop', 1, 1),
      Article.find_published('intervention', 1, 1),
    ]
    render :template => 'layouts/article'
  end

  def radiomediaall
    find_list_articles_by_category 'radiomedia'
    return unless @partial.nil?
    @side_articles = [
      Article.find_published('radioactu', 1, 1),
      Article.find_published('educpop', 1, 1),
      Article.find_published('intervention', 1, 1),
    ]
    render :template => 'layouts/index'
  end

  def intervention
    @side_articles = [
      Article.find_published('radioactu', 1, 1),
      Article.find_published('educpop', 1, 1),
      Article.find_published('radiomedia', 1, 1),
    ]
    render :template => 'layouts/article'
  end

  def interventionall
    find_list_articles_by_category 'intervention'
    return unless @partial.nil?
    @side_articles = [
      Article.find_published('radioactu', 1, 1),
      Article.find_published('educpop', 1, 1),
      Article.find_published('radiomedia', 1, 1),
    ]
    render :template => 'layouts/index'
  end

  def son
    @side_articles = [
      Article.find_published('edito', 1, 1),
      Article.find_published('dossier', 1, 1),
      Article.find_published('com', 1, 1),
      Article.find_published('actu', 1, 1),
      Article.find_published('inter', 1, 1)
    ]
    render :template => 'layouts/article'
  end

  # RSS podcast output.
  def rss
    @root_path = url_for podcast_path(:only_path => false)
    @rss_path = url_for podcast_feed_path(:only_path => false)
    @articles = Article.find_published_audio(1, 50)
    if stale?(:etag => "podcast/rss", :last_modified => @articles[0].nil? ? nil : @articles[0].updated_at, :public => true)
      render :template => '/layouts/rss'
    end
  end
end
