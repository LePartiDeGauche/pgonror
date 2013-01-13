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
class ActualitesController < ApplicationController
  before_filter :find_article, :only => [:edito, :actualite, :communique, :international, :dossier]
  caches_action :index, :layout => false, :if => Proc.new { can_cache? }
  caches_action :editos, :layout => false, :if => Proc.new { can_cache? } 
  caches_action :edito, :layout => false, :if => Proc.new { can_cache? }
  caches_action :actualites, :layout => false, :if => Proc.new { can_cache? }
  caches_action :actualite, :layout => false, :if => Proc.new { can_cache? }
  caches_action :communiques, :layout => false, :if => Proc.new { can_cache? }
  caches_action :communique, :layout => false, :if => Proc.new { can_cache? }
  caches_action :tout_international, :layout => false, :if => Proc.new { can_cache? }
  caches_action :international, :layout => false, :if => Proc.new { can_cache? }
  caches_action :dossiers, :layout => false, :if => Proc.new { can_cache? }
  caches_action :dossier, :layout => false, :if => Proc.new { can_cache? }

  def index
    @editos = Article.find_published 'edito', 1, 15
    @dossiers = Article.find_published 'dossier', 1, 15
    @communiques = Article.find_published 'com', 1, 3
    @actus = Article.find_published 'actu', 1, 3
    @tout_international = Article.find_published 'inter', 1, 3
  end

  def editos
    find_list_articles_by_category 'edito'
    return if params[:partial].present?
    @side_articles = [
      Article.find_published('dossier', 1, 1),
      Article.find_published('com', 1, 1),
      Article.find_published('actu', 1, 1),
      Article.find_published('inter', 1, 1)
    ]
    render :template => 'layouts/index'
    
  end

  def edito
    @side_articles = [
      Article.find_published('dossier', 1, 1),
      Article.find_published('com', 1, 1),
      Article.find_published('actu', 1, 1),
      Article.find_published('inter', 1, 1)
    ]
    render :template => 'layouts/article'
  end

  def actualites
    find_list_articles_by_category 'actu'
    return if params[:partial].present?
    @side_articles = [
      Article.find_published('edito', 1, 1),
      Article.find_published('dossier', 1, 1),
      Article.find_published('com', 1, 1),
      Article.find_published('inter', 1, 1)
    ]
    render :template => 'layouts/index'
  end

  def actualite
    @side_articles = [
      Article.find_published('edito', 1, 1),
      Article.find_published('dossier', 1, 1),
      Article.find_published('com', 1, 1),
      Article.find_published('inter', 1, 1)
    ]
    render :template => 'layouts/article'
  end

  def communiques
    find_list_articles_by_category 'com'
    return if params[:partial].present?
    @side_articles = [
      Article.find_published('edito', 1, 1),
      Article.find_published('dossier', 1, 1),
      Article.find_published('actu', 1, 1),
      Article.find_published('inter', 1, 1)
    ]
    render :template => 'layouts/index'
  end

  def communique
    @side_articles = [
      Article.find_published('edito', 1, 1),
      Article.find_published('dossier', 1, 1),
      Article.find_published('actu', 1, 1),
      Article.find_published('inter', 1, 1)
    ]
    render :template => 'layouts/article'
  end

  def tout_international
    find_list_articles_by_category 'inter'
    return if params[:partial].present?
    @side_articles = [
      Article.find_published('edito', 1, 1),
      Article.find_published('dossier', 1, 1),
      Article.find_published('com', 1, 1),
      Article.find_published('actu', 1, 1)
    ]
    render :template => 'layouts/index'
  end

  def international
    @side_articles = [
      Article.find_published('edito', 1, 1),
      Article.find_published('dossier', 1, 1),
      Article.find_published('com', 1, 1),
      Article.find_published('actu', 1, 1)
    ]
    render :template => 'layouts/article'
  end

  def dossiers
    find_list_articles_by_category 'dossier'
    return if params[:partial].present?
    @side_articles = [
      Article.find_published('edito', 1, 1),
      Article.find_published('com', 1, 1),
      Article.find_published('actu', 1, 1),
      Article.find_published('inter', 1, 1)
    ]
    render :template => 'layouts/index'
  end

  def dossier
    @side_articles = [
      Article.find_published('edito', 1, 1),
      Article.find_published('com', 1, 1),
      Article.find_published('actu', 1, 1),
      Article.find_published('inter', 1, 1)
    ]
    render :template => 'layouts/article'
  end
end