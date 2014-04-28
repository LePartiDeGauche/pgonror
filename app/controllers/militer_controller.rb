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
  before_action :find_article, :only => [:evenement, :tract, :affiche, :kit]
  before_action :load_side_articles, :only => [:index, :inscription, :evenement, :agenda]

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
    @root_path = url_for agenda_path(:only_path => false)
    @rss_path = url_for militer_rss_feed_path(:only_path => false)
    @articles = Article.find_published_order_by_start_datetime 'evenement', 1, 50
    if stale?(:etag => "militer/rss", :last_modified => @articles[0].nil? ? nil : @articles[0].updated_at, :public => true)
      render :template => 'layouts/rss'
    end
  end
  
  def tracts
    find_list_articles_by_category 'tract'
    return unless @partial.nil?
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
    return unless @partial.nil?
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
    return unless @partial.nil?
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
    @subscription = Subscription.new(subscription_parameters)
    if @subscription.save
      flash.now[:notice] = t('action.subscription.created')
      @subscription.email_notification
      create_subscription
    end
    render :action => "index"
  end

private

  # Returns the parameters that are allowed for mass-update.
  def subscription_parameters
    return nil if params[:subscription].nil?
    params.require(:subscription).permit(:last_name,
                                        :first_name,
                                        :email,
                                        :address,
                                        :zip_code,
                                        :city,
                                        :phone,
                                        :comment)
  end

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