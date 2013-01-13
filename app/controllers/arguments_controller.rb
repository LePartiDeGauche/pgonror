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
  before_filter :find_article, :only => [:programme, :argument, :legislative]
  caches_action :index, :layout => false, :if => Proc.new { not user_signed_in? }
  caches_action :leprogramme, :layout => false, :if => Proc.new { @page == 1 and not user_signed_in? }
  caches_action :programme, :layout => false, :if => Proc.new { @page == 1 and not user_signed_in? }
  caches_action :arguments, :layout => false, :if => Proc.new { @page == 1 and @page_heading.blank? and not user_signed_in? }
  caches_action :argument, :layout => false, :if => Proc.new { @page == 1 and @page_heading.blank? and not user_signed_in? }
  caches_action :legislatives, :layout => false, :if => Proc.new { @page == 1 and @page_heading.blank? and not user_signed_in? }
  caches_action :legislative, :layout => false, :if => Proc.new { @page == 1 and @page_heading.blank? and not user_signed_in? }
  
  def index
    @arguments = Article.find_published 'argument', 1, 40
    @legislatives = Article.find_published 'legislative', 1, 10
    @programmes = Article.find_published 'programme', 1, 10
  end
  
  def leprogramme
    find_list_articles_by_category 'programme'
    return if params[:partial].present?
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
    return if params[:partial].present?
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
    return if params[:partial].present?
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