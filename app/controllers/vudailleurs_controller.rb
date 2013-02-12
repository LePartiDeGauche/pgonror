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
class VudailleursController < ApplicationController
  before_filter :find_article, :only => [:articleweb, :articleblog, :blog]
  before_filter :load_side_articles, :only => [:articleweb, :articlesweb,
                                               :blog,
                                               :envoyer_message]

  caches_action :index, :if => Proc.new { can_cache? }
  caches_action :articlesweb, :if => Proc.new { can_cache? }
  caches_action :articleweb, :if => Proc.new { can_cache? }
  caches_action :articlesblog, :if => Proc.new { can_cache? }
  caches_action :articleblog, :if => Proc.new { can_cache? }
  caches_action :blogs, :if => Proc.new { can_cache? }
  caches_action :blog, :if => Proc.new { can_cache? }

  def index
    @articlesweb = Article.find_published 'web', 1, 3
    @articlesblog = Article.find_published 'directblog', 1, 6
  end
  
  def articleweb
    create_request
  end

  def articlesweb
    create_request
    find_list_articles_by_category 'web'
    return unless @partial.nil?
  end
  
  def articleblog
    @side_articles = [
      Article.find_published('web', 1, 5)
    ]
    render :template => 'layouts/article'
  end
  
  def articlesblog
    find_list_articles_by_category 'directblog'
    return unless @partial.nil?
    @side_articles = [
      Article.find_published('web', 1, 5)
    ]
    render :template => 'layouts/index'
  end
  
  def blogs
    @articles = Article.find_published_order_by_title 'blog', 1, 999
    @side_articles = [
      Article.find_published('web', 1, 5)
    ]
    render :template => 'layouts/index'
  end
  
  def blog
    @attached_articles = @article.present? ? @article.find_published_by_source(@page) : nil
    @pages = @article.present? ? @article.count_pages_published_by_source : 0
    unless @partial.nil?
      render :partial => 'layouts/articles_1col_2_on_3', :locals => { :articles => @attached_articles, :partial => true }
      return
    end
  end

  def envoyer_message
    @request = Request.new(params[:request])
    @request.recipient = "X"
    saved = false
    begin
      @request.transaction do
        @request.save!
        saved = true
      end
    rescue ActiveRecord::RecordInvalid => invalid
      log_warning "envoyer_message", invalid
    end
    if saved
      flash.now[:notice] = t('action.request.created')
      @request.email_notification
      create_request
    end
    @pages = Article.count_pages_published 'web'
    @articles = Article.find_published 'web', @page
    render :action => "articlesweb"
  end

private

  def create_request
    @request = Request.new
  end

  def load_side_articles
    @articlesweb = Article.find_published 'web'
    @articlesblog = Article.find_published 'directblog'
  end
end