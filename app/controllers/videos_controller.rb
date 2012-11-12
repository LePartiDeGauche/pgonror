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
                                         :fdg]
  before_filter :load_side_articles, :only => [:lateledegauche,
                                               :conferences, :conference,
                                               :videospresdechezvous, :presdechezvous,
                                               :medias, :media,
                                               :videosagitprop, :agitprop,
                                               :touteducpop, :educpop,
                                               :videosencampagne, :encampagne,
                                               :videosfdg, :fdg]

  caches_action :index, :layout => false, :if => Proc.new { @page == 1 and @page_heading.blank? and not user_signed_in? }

  def index
    @pages = Article.count_pages_published_by_heading 'video', @page_heading
    @articles = Article.find_published_by_heading 'video', @page_heading, @page
    @headings = Article.find_published_group_by_heading 'video'
  end

  def video
    @headings = Article.find_published_group_by_heading 'video'
  end

  def lateledegauche
    @pages = Article.count_pages_published_by_heading 'video', @page_heading
    @articles = Article.find_published_by_heading 'video', @page_heading, @page
    @headings = Article.find_published_group_by_heading 'video'
  end

  def conferences
  end

  def conference
  end

  def videospresdechezvous
  end

  def presdechezvous
  end

  def medias
  end

  def media
  end

  def videosagitprop
  end

  def agitprop
  end

  def touteducpop
  end

  def educpop
  end

  def videosencampagne
  end

  def encampagne
  end

  def videosfdg
  end

  def fdg
  end

private

  def load_side_articles
    @conferences = Article.find_published 'conference', 1, 1
    @videosevenement = Article.find_published 'videoevenement', 1, 1
    @medias = Article.find_published 'media', 1, 1
    @videosagitprop = Article.find_published 'videoagitprop', 1, 1
    @videoseduc = Article.find_published 'videoeduc', 1, 1
    @encampagne = Article.find_published 'encampagne', 1, 1
    @videosfdg = Article.find_published 'videofdg', 1, 1
  end
end