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
  before_filter :find_article, :only => [:date, :vendredi, :livre, :lecture, :revue ]
  before_filter :load_side_articles, :only => [:index, 
                                               :date, :dates,
                                               :vendredi, :vendredis,
                                               :livre, :librairie,
                                               :lecture, :lectures,
                                               :revue, :revues]

  caches_action :index, :layout => false
  caches_action :dates, :layout => false, :if => Proc.new { @page == 1 }
  caches_action :vendredis, :layout => false, :if => Proc.new { @page == 1 }
  caches_action :librairie, :layout => false, :if => Proc.new { @page == 1 }
  caches_action :lectures, :layout => false, :if => Proc.new { @page == 1 }
  caches_action :revues, :layout => false, :if => Proc.new { @page == 1 }

  def index
  end
  
  def dates
    @pages = Article.count_pages_published 'date'
    @articles = Article.find_published 'date', @page
  end
  
  def date
  end
  
  def vendredis
    @pages = Article.count_pages_published 'vendredi'
    @articles = Article.find_published 'vendredi', @page
  end
  
  def vendredi
  end
  
  def librairie
    @pages = Article.count_pages_published 'livre'
    @articles = Article.find_published 'livre', @page
  end
  
  def livre
  end
  
  def lectures
    @pages = Article.count_pages_published 'lecture'
    @articles = Article.find_published 'lecture', @page
  end
  
  def lecture
  end
  
  def revues
    @pages = Article.count_pages_published 'revue'
    @articles = Article.find_published 'revue', @page
  end
  
  def revue
  end
  
private

  def load_side_articles
    @dates = Article.find_published 'date', 1, 1
    @vendredis = Article.find_published 'vendredi', 1, 3
    @livres = Article.find_published 'livre', 1, 1
    @lectures = Article.find_published 'lecture', 1, 1
    @revues = Article.find_published 'revue', 1, 1
  end
end