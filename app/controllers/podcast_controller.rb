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

# Controller for the podcast.
class PodcastController < ApplicationController
  before_filter :find_article, :only => [:son]

  caches_action :index, :layout => false, :if => Proc.new { @page == 1 and params[:heading].blank? and not user_signed_in? }

  def index
    @pages = Article.count_pages_published_by_heading 'son', params[:heading]
    @articles = Article.find_published_by_heading 'son', params[:heading], @page
    @headings = Article.find_published_group_by_heading 'son'
    session[:heading] = params[:heading]
    @editos = Article.find_published 'edito', 1, 1
    @actus = Article.find_published 'actu', 1, 1
  end

  def son
    @headings = Article.find_published_group_by_heading 'son'
    @editos = Article.find_published 'edito', 1, 1
    @actus = Article.find_published 'actu', 1, 1
  end

  # RSS podcast output.
  def rss
    @articles = Article.find_published('son', 1, 50)
  end
end