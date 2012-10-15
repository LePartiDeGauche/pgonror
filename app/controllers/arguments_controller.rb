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
class ArgumentsController < ApplicationController
  before_filter :find_article, :only => [:programme, :argument, :legislative]
  before_filter :load_side_articles, :only => [:index, 
                                               :programme, :leprogramme, 
                                               :argument, :arguments,
                                               :legislative, :legislatives]
  caches_action :index, :layout => false
  caches_action :leprogramme, :layout => false, :if => Proc.new { @page == 1 }
  caches_action :arguments, :layout => false, :if => Proc.new { @page == 1 }
  caches_action :legislatives, :layout => false, :if => Proc.new { @page == 1 and params[:heading].blank? }
  
  def index
  end
  
  def leprogramme
    @pages = Article.count_pages_published 'programme'
    @articles = Article.find_published 'programme', @page
  end
  
  def programme
  end
  
  def arguments
    @pages = Article.count_pages_published 'argument'
    @articles = Article.find_published 'argument', @page
  end
  
  def argument
  end
  
  def legislatives
    @articles = Article.find_by_criteria({:status => Article::ONLINE, 
                                          :category => 'legislative', 
                                          :heading => params[:heading]}, @page)
    @pages = Article.count_pages_by_criteria({:status => Article::ONLINE, 
                                              :category => 'legislative', 
                                              :heading => params[:heading]})
    @headings = Article.find_published_group_by_heading 'legislative'
    session[:heading] = params[:heading]
  end
  
  def legislative
  end

private

  def load_side_articles
    @arguments = Article.find_published 'argument', 1, 3
    @legislatives = Article.find_published 'legislative', 1, 10
    @programmes = Article.find_published 'programme', 1, 3
  end
end