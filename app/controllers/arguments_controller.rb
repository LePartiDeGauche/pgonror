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
class ArgumentsController < ApplicationController
  before_action :find_article, :only => [:programme, :argument, :legislative]
  
  def index
    @programmes = Article.find_published 'programme', 1, 10
    @arguments = Article.find_published 'argument', 1, 20
    @legislatives = Article.find_published 'legislative', 1, 5
  end
  
  def leprogramme
    find_list_articles_by_category 'programme'
    return unless @partial.nil?
    @side_articles = [
      Article.find_published('argument', 1, 5),
      Article.find_published('legislative', 1, 1)
    ]
    render :template => 'layouts/index'
  end
  
  def programme
    @side_articles = [
      Article.find_published('argument', 1, 5),
      Article.find_published('legislative', 1, 1)
    ]
    render :template => 'layouts/article'
  end
  
  def arguments
    find_list_articles_by_category 'argument'
    return unless @partial.nil?
    @side_articles = [
      Article.find_published('programme', 1, 1),
      Article.find_published('legislative', 1, 5)
    ]
    render :template => 'layouts/index'
  end
  
  def argument
    @side_articles = [
      Article.find_published('programme', 1, 1),
      Article.find_published('legislative', 1, 5)
    ]
    render :template => 'layouts/article'
  end
  
  def legislatives
    find_list_articles_by_category 'legislative'
    return unless @partial.nil?
    @side_articles = [
      Article.find_published('programme', 1, 1),
      Article.find_published('argument', 1, 5)
    ]
    render :template => 'layouts/index'
  end
  
  def legislative
    @side_articles = [
      Article.find_published('programme', 1, 1),
      Article.find_published('argument', 1, 5)
    ]
    render :template => 'layouts/article'
  end
end