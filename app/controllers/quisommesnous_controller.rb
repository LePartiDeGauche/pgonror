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
class QuisommesnousController < ApplicationController
  before_filter :find_article, :only => [:identite, 
                                          :instance, 
                                          :commission]
  caches_action :index, :layout => false, :if => Proc.new { not user_signed_in? }

  def index
    @identites = Article.find_published 'identite', 1
    @instances = Article.find_published 'instance', 1
    @commissions = Article.find_published 'commission', 1
  end
  
  def identite
    @side_articles = [
      Article.find_published('instance', 1, 2),
      Article.find_published('commission', 1, 2),
      Article.find_published('identite', 1, 2)
    ]
    render :template => 'layouts/article'
  end

  def instance
    @side_articles = [
      Article.find_published('identite', 1, 2),
      Article.find_published('commission', 1, 2),
      Article.find_published('instance', 1, 2)
    ]
    render :template => 'layouts/article'
  end

  def commission
    @side_articles = [
      Article.find_published('instance', 1, 2),
      Article.find_published('identite', 1, 2),
      Article.find_published('commission', 1, 2)
    ]
    render :template => 'layouts/article'
  end
end