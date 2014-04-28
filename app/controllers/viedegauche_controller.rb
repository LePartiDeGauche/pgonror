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
class ViedegaucheController < ApplicationController
  before_action :find_article, :only => [:article, :journalvdg]

  def index
    find_list_articles_by_category 'articlevdg'
    return unless @partial.nil?
    @side_articles = [
      Article.find_published('vdg', 1, 1),
      Article.find_published('actu', 1, 1),
      Article.find_published('dossier', 1, 1),
      Article.find_published('com', 1, 1)
    ]
    render :template => 'layouts/index'
  end

  def article
    @side_articles = [
      Article.find_published('vdg', 1, 1),
      Article.find_published('actu', 1, 1),
      Article.find_published('dossier', 1, 1),
      Article.find_published('com', 1, 1)
    ]
    render :template => 'layouts/article'
  end
  
  def journalvdg
    @side_articles = [
      Article.find_published('articlevdg', 1, 1),
      Article.find_published('actu', 1, 1),
      Article.find_published('dossier', 1, 1),
      Article.find_published('com', 1, 1)
    ]
    render :template => 'layouts/article'
  end
  
  def journauxvdg
    find_list_articles_by_category 'vdg'
    return unless @partial.nil?
    @side_articles = [
      Article.find_published('articlevdg', 1, 1),
      Article.find_published('actu', 1, 1),
      Article.find_published('dossier', 1, 1),
      Article.find_published('com', 1, 1)
    ]
    render :template => 'layouts/index'
  end
end