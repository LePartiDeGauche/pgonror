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
class EducpopController < ApplicationController
  before_action :find_article, :only => [:date, :livre, :lecture, :revue ]

  def index
    @dates = Article.find_published 'date', 1, 1
    @livres = Article.find_published 'livre', 1, 1
    @lectures = Article.find_published 'lecture', 1, 1
    @revues = Article.find_published 'revue', 1, 1
  end
  
  def dates
    find_list_articles_by_category 'date'
    return unless @partial.nil?
    @side_articles = [
      Article.find_published('livre', 1, 1),
      Article.find_published('lecture', 1, 1),
      Article.find_published('revue', 1, 1)
    ]
    render :template => 'layouts/index'
  end
  
  def date
    @side_articles = [
      Article.find_published('livre', 1, 1),
      Article.find_published('lecture', 1, 1),
      Article.find_published('revue', 1, 1)
    ]
    render :template => 'layouts/article'
  end
  
  def librairie
    find_list_articles_by_category 'livre'
    return unless @partial.nil?
    @side_articles = [
      Article.find_published('date', 1, 1),
      Article.find_published('lecture', 1, 1),
      Article.find_published('revue', 1, 1)
    ]
    render :template => 'layouts/index'
  end
  
  def livre
    @side_articles = [
      Article.find_published('date', 1, 1),
      Article.find_published('lecture', 1, 1),
      Article.find_published('revue', 1, 1)
    ]
    render :template => 'layouts/article'
  end
  
  def lectures
    find_list_articles_by_category 'lecture'
    return unless @partial.nil?
    @side_articles = [
      Article.find_published('date', 1, 1),
      Article.find_published('livre', 1, 1),
      Article.find_published('revue', 1, 1)
    ]
    render :template => 'layouts/index'
  end
  
  def lecture
    @side_articles = [
      Article.find_published('date', 1, 1),
      Article.find_published('livre', 1, 1),
      Article.find_published('revue', 1, 1)
    ]
    render :template => 'layouts/article'
  end
  
  def revues
    find_list_articles_by_category 'revue'
    return unless @partial.nil?
    @side_articles = [
      Article.find_published('date', 1, 1),
      Article.find_published('livre', 1, 1),
      Article.find_published('lecture', 1, 1)
    ]
    render :template => 'layouts/index'
  end
  
  def revue
    @side_articles = [
      Article.find_published('date', 1, 1),
      Article.find_published('livre', 1, 1),
      Article.find_published('lecture', 1, 1)
    ]
    render :template => 'layouts/article'
  end
end