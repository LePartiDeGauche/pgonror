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
class MiliterController < ApplicationController
  before_filter :find_article, :only => [:evenement, :tract, :affiche, :kit]
  before_filter :load_side_articles, :only => [:index, :inscription, :evenement, :agenda]
  caches_action :index, :layout => false, :expires_in => 1.hour, :if => Proc.new { can_cache? }
  caches_action :agenda, :layout => false, :expires_in => 1.hour, :if => Proc.new { can_cache? }
  caches_action :evenement, :layout => false, :expires_in => 1.hour, :if => Proc.new { can_cache? }
  caches_action :tracts, :layout => false, :if => Proc.new { can_cache? }
  caches_action :tract, :layout => false, :if => Proc.new { can_cache? }
  caches_action :kits, :layout => false, :if => Proc.new { can_cache? }
  caches_action :kit, :layout => false, :if => Proc.new { can_cache? }
  caches_action :affiches, :layout => false, :if => Proc.new { can_cache? }
  caches_action :affiche, :layout => false, :if => Proc.new { can_cache? }
  caches_action :rss, :expires_in => 1.hour, :if => Proc.new { can_cache? }

  def index
    create_subscription
  end
  
  def evenement
  end

  def agenda
    @articles = Article.find_published_order_by_start_datetime 'evenement', 1, 999
  end

  # RSS output based on recent articles.
  def rss
    @articles = Article.find_published_order_by_start_datetime 'evenement', 1, 50
    render :template => 'layouts/rss'
  end
  
  def tracts
    find_list_articles_by_category 'tract'
    return if params[:partial].present?
    @side_articles = [
      Article.find_published('affiche', 1, 3),
      Article.find_published('kit', 1, 1)
    ]
    render :template => 'layouts/index'
  end

  def tract
    @side_articles = [
      Article.find_published('affiche', 1, 3),
      Article.find_published('kit', 1, 1)
    ]
    render :template => 'layouts/article'
  end

  def kits
    find_list_articles_by_category 'kit'
    return if params[:partial].present?
    @side_articles = [
      Article.find_published('tract', 1, 2),
      Article.find_published('affiche', 1, 2)
    ]
    render :template => 'layouts/index'
  end

  def kit
    @side_articles = [
      Article.find_published('tract', 1, 2),
      Article.find_published('affiche', 1, 2)
    ]
    render :template => 'layouts/article'
  end

  def affiches
    find_list_articles_by_category 'affiche'
    return if params[:partial].present?
    @side_articles = [
      Article.find_published('tract', 1, 3),
      Article.find_published('kit', 1, 1)
    ]
    render :template => 'layouts/index'
  end

  def affiche
    @side_articles = [
      Article.find_published('tract', 1, 3),
      Article.find_published('kit', 1, 1)
    ]
    render :template => 'layouts/article'
  end

  def inscription
    @subscription = Subscription.new(params[:subscription])
    if @subscription.save
      flash.now[:notice] = t('action.subscription.created')
      @subscription.email_notification
      create_subscription
    end
    render :action => "index"
  end

private

  def create_subscription
    @subscription = Subscription.new
  end

  def load_side_articles
    @campagne = Article.find_published('campagne', 1, 1)[0]
    @tracts = Article.find_published 'tract', 1, 1
    @kits = Article.find_published 'kit', 1, 1
    @affiches = Article.find_published 'affiche', 1, 1
    @evenements = Article.find_published_order_by_start_datetime 'evenement', 1, 15
  end
end