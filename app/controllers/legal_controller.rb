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

# Controller for the web site legal page.
class LegalController < ApplicationController
  before_filter :find_article, :only => [:archive, :source]

  caches_action :index, :layout => false
  
  # Legal information page.
  def index
    @legal = Article.find_published('legal', 1, 1)[0]
    @source_archives = Article.find_published('codearchive', 1, 1)
  end

  def archive
    @sources = @article.present? ?
      Article::find_by_criteria({:status => Article::ONLINE, :parent => @article.id}, 1, 999).order('title') :
      nil
  end

  def source
  end
end