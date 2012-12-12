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
class VideosController < ApplicationController
  before_filter :find_article, :only => [:video,
                                         :conference,
                                         :presdechezvous,
                                         :media,
                                         :agitprop,
                                         :educpop,
                                         :encampagne,
                                         :web]

  caches_action :index, :layout => false, :if => Proc.new { @page == 1 and @page_heading.blank? and not user_signed_in? }
  caches_action :lateledegauche, :layout => false, :if => Proc.new { not user_signed_in? }
  caches_action :conferences, :layout => false, :if => Proc.new { @page == 1 and @page_heading.blank? and not user_signed_in? } 
  caches_action :videospresdechezvous, :layout => false, :if => Proc.new { @page == 1 and @page_heading.blank? and not user_signed_in? }
  caches_action :medias, :layout => false, :if => Proc.new { @page == 1 and @page_heading.blank? and not user_signed_in? }
  caches_action :videosagitprop, :layout => false, :if => Proc.new { @page == 1 and @page_heading.blank? and not user_signed_in? }
  caches_action :touteducpop, :layout => false, :if => Proc.new { @page == 1 and @page_heading.blank? and not user_signed_in? }
  caches_action :videosencampagne, :layout => false, :if => Proc.new { @page == 1 and @page_heading.blank? and not user_signed_in? }
  caches_action :toutweb, :layout => false, :if => Proc.new { @page == 1 and @page_heading.blank? and not user_signed_in? }

  def index
    find_list_articles_by_category 'video'
    return if params[:partial].present?
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
    return if params[:partial].present?
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
    return if params[:partial].present?
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
    return if params[:partial].present?
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
    return if params[:partial].present?
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
    return if params[:partial].present?
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
    return if params[:partial].present?
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
    return if params[:partial].present?
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