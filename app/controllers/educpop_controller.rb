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
class EducpopController < ApplicationController
  before_filter :find_article, :only => [:date, :livre, :lecture, :revue ]
  caches_action :index, :layout => false, :if => Proc.new { not user_signed_in? }
  caches_action :dates, :layout => false, :if => Proc.new { @page == 1 and @page_heading.blank? and not user_signed_in? }
  caches_action :librairie, :layout => false, :if => Proc.new { @page == 1 and @page_heading.blank? and not user_signed_in? }
  caches_action :lectures, :layout => false, :if => Proc.new { @page == 1 and @page_heading.blank? and not user_signed_in? }
  caches_action :revues, :layout => false, :if => Proc.new { @page == 1 and @page_heading.blank? and not user_signed_in? }

  def index
    @dates = Article.find_published 'date', 1, 1
    @livres = Article.find_published 'livre', 1, 1
    @lectures = Article.find_published 'lecture', 1, 1
    @revues = Article.find_published 'revue', 1, 1
  end
  
  def dates
    find_list_articles_by_category 'date'
    return if params[:partial].present?
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
    return if params[:partial].present?
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
    return if params[:partial].present?
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
    return if params[:partial].present?
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