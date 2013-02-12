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
class VideosController < ApplicationController
  before_filter :find_article, :only => [:video,
                                         :conference,
                                         :presdechezvous,
                                         :media,
                                         :agitprop,
                                         :educpop,
                                         :encampagne,
                                         :web]
  caches_action :index, :if => Proc.new { can_cache? }
  caches_action :lateledegauche, :if => Proc.new { can_cache? }
  caches_action :conferences, :if => Proc.new { can_cache? } 
  caches_action :conference, :if => Proc.new { can_cache? } 
  caches_action :videospresdechezvous, :if => Proc.new { can_cache? }
  caches_action :presdechezvous, :if => Proc.new { can_cache? }
  caches_action :medias, :if => Proc.new { can_cache? }
  caches_action :media, :if => Proc.new { can_cache? }
  caches_action :videosagitprop, :if => Proc.new { can_cache? }
  caches_action :agitprop, :if => Proc.new { can_cache? }
  caches_action :touteducpop, :if => Proc.new { can_cache? }
  caches_action :educpop, :if => Proc.new { can_cache? }
  caches_action :videosencampagne, :if => Proc.new { can_cache? }
  caches_action :encampagne, :if => Proc.new { can_cache? }
  caches_action :toutweb, :if => Proc.new { can_cache? }
  caches_action :web, :if => Proc.new { can_cache? }
  caches_action :rss, :expires_in => 1.hour, :if => Proc.new { can_cache? }

  def index
    find_list_articles_by_category 'video'
    return unless @partial.nil?
    @side_articles = [
      Article.find_published('videoevenement', 1, 1),
      Article.find_published('media', 1, 1),
      Article.find_published('videoagitprop', 1, 1),
      Article.find_published('videoeduc', 1, 1),
      Article.find_published('encampagne', 1, 1),
      Article.find_published('videoweb', 1, 1)
    ]
    render :template => 'layouts/index'
  end

  # RSS output based on recent articles.
  def rss
    @root_path = url_for lateledegauche_path(:only_path => false)
    @articles = Article.find_published_video 1, 50
    render :template => 'layouts/rss'
  end
  
  def video
    @side_articles = [
      Article.find_published('conference', 1, 1),
      Article.find_published('videoagitprop', 1, 1),
      Article.find_published('videoeduc', 1, 1),
      Article.find_published('videoweb', 1, 1)
    ]
    render :template => 'layouts/article'
  end

  def lateledegauche
    @zoom = Article.find_published_zoom_video 1, 5
    @conferences = Article.find_published_exclude_zoom_video 'conference', 1, 1
    @videosevenement = Article.find_published_exclude_zoom_video 'videoevenement', 1, 1
    @medias = Article.find_published_exclude_zoom_video 'media', 1, 10
    @videosagitprop = Article.find_published_exclude_zoom_video 'videoagitprop', 1, 1
    @videoseduc = Article.find_published_exclude_zoom_video 'videoeduc', 1, 1
    @encampagne = Article.find_published_exclude_zoom_video 'encampagne', 1, 1
    @videosfdg = Article.find_published_exclude_zoom_video 'videoweb', 1, 1
  end

  def conferences
    find_list_articles_by_category 'conference'
    return unless @partial.nil?
    @side_articles = [
      Article.find_published('videoevenement', 1, 1),
      Article.find_published('media', 1, 1),
      Article.find_published('videoagitprop', 1, 1),
      Article.find_published('videoeduc', 1, 1),
      Article.find_published('encampagne', 1, 1),
      Article.find_published('videoweb', 1, 1)
    ]
    render :template => 'layouts/index'
  end

  def conference
    @side_articles = [
      Article.find_published('videoevenement', 1, 1),
      Article.find_published('media', 1, 1),
      Article.find_published('encampagne', 1, 1),
      Article.find_published('videoweb', 1, 1)
    ]
    render :template => 'layouts/article'
  end

  def videospresdechezvous
    find_list_articles_by_category 'videoevenement'
    return unless @partial.nil?
    @side_articles = [
      Article.find_published('conference', 1, 1),
      Article.find_published('media', 1, 1),
      Article.find_published('videoagitprop', 1, 1),
      Article.find_published('videoeduc', 1, 1),
      Article.find_published('encampagne', 1, 1),
      Article.find_published('videoweb', 1, 1)
    ]
    render :template => 'layouts/index'
  end

  def presdechezvous
    @side_articles = [
      Article.find_published('conference', 1, 1),
      Article.find_published('videoagitprop', 1, 1),
      Article.find_published('videoeduc', 1, 1),
      Article.find_published('videoweb', 1, 1)
    ]
    render :template => 'layouts/article'
  end

  def medias
    find_list_articles_by_category 'media'
    return unless @partial.nil?
    @side_articles = [
      Article.find_published('conference', 1, 1),
      Article.find_published('videoevenement', 1, 1),
      Article.find_published('videoagitprop', 1, 1),
      Article.find_published('videoeduc', 1, 1),
      Article.find_published('encampagne', 1, 1),
      Article.find_published('videoweb', 1, 1)
    ]
    render :template => 'layouts/index'
  end

  def media
    @side_articles = [
      Article.find_published('videoevenement', 1, 1),
      Article.find_published('videoeduc', 1, 1),
      Article.find_published('encampagne', 1, 1),
      Article.find_published('videoweb', 1, 1)
    ]
    render :template => 'layouts/article'
  end

  def videosagitprop
    find_list_articles_by_category 'videoagitprop'
    return unless @partial.nil?
    @side_articles = [
      Article.find_published('conference', 1, 1),
      Article.find_published('videoevenement', 1, 1),
      Article.find_published('media', 1, 1),
      Article.find_published('videoeduc', 1, 1),
      Article.find_published('encampagne', 1, 1),
      Article.find_published('videoweb', 1, 1)
    ]
    render :template => 'layouts/index'
  end

  def agitprop
    @side_articles = [
      Article.find_published('conference', 1, 1),
      Article.find_published('media', 1, 1),
      Article.find_published('videoeduc', 1, 1),
      Article.find_published('encampagne', 1, 1)
    ]
    render :template => 'layouts/article'
  end

  def touteducpop
    find_list_articles_by_category 'videoeduc'
    return unless @partial.nil?
    @side_articles = [
      Article.find_published('conference', 1, 1),
      Article.find_published('videoevenement', 1, 1),
      Article.find_published('media', 1, 1),
      Article.find_published('videoagitprop', 1, 1),
      Article.find_published('encampagne', 1, 1),
      Article.find_published('videoweb', 1, 1)
    ]
    render :template => 'layouts/index'
  end

  def educpop
    @side_articles = [
      Article.find_published('videoevenement', 1, 1),
      Article.find_published('media', 1, 1),
      Article.find_published('encampagne', 1, 1),
      Article.find_published('videoweb', 1, 1)
    ]
    render :template => 'layouts/article'
  end

  def videosencampagne
    find_list_articles_by_category 'encampagne'
    return unless @partial.nil?
    @side_articles = [
      Article.find_published('conference', 1, 1),
      Article.find_published('videoevenement', 1, 1),
      Article.find_published('media', 1, 1),
      Article.find_published('videoagitprop', 1, 1),
      Article.find_published('videoeduc', 1, 1),
      Article.find_published('videoweb', 1, 1)
    ]
    render :template => 'layouts/index'
  end

  def encampagne
    @side_articles = [
      Article.find_published('conference', 1, 1),
      Article.find_published('videoevenement', 1, 1),
      Article.find_published('videoagitprop', 1, 1),
      Article.find_published('videoeduc', 1, 1)
    ]
    render :template => 'layouts/article'
  end

  def toutweb
    find_list_articles_by_category 'videoweb'
    return unless @partial.nil?
    @side_articles = [
      Article.find_published('conference', 1, 1),
      Article.find_published('videoevenement', 1, 1),
      Article.find_published('media', 1, 1),
      Article.find_published('videoagitprop', 1, 1),
      Article.find_published('videoeduc', 1, 1),
      Article.find_published('encampagne', 1, 1)
    ]
    render :template => 'layouts/index'
  end

  def web
    @side_articles = [
      Article.find_published('conference', 1, 1),
      Article.find_published('media', 1, 1),
      Article.find_published('videoagitprop', 1, 1),
      Article.find_published('videoeduc', 1, 1)
    ]
    render :template => 'layouts/article'
  end
end