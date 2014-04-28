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
  before_action :find_article, :only => [:son]

  def index
    find_list_articles_by_category 'son'
    return unless @partial.nil?
    @side_articles = [
      Article.find_published('edito', 1, 1),
      Article.find_published('dossier', 1, 1),
      Article.find_published('com', 1, 1),
      Article.find_published('actu', 1, 1),
      Article.find_published('inter', 1, 1)
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
    @articles = Article.find_published('son', 1, 50)
    if stale?(:etag => "podcast/rss", :last_modified => @articles[0].nil? ? nil : @articles[0].updated_at, :public => true)
      render :template => '/layouts/rss'
    end
  end
end