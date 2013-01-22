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
class ContactController < ApplicationController
  before_filter :find_article, :only => [:departement]
  before_filter :load_index
  caches_action :index, :layout => false, :if => Proc.new { can_cache? }
  caches_action :departement, :layout => false, :if => Proc.new { can_cache? }

  def index
    create_request
  end
  
  def departement
    @attached_articles = @article.present? ? @article.find_published_by_source(@page) : nil
    @pages = @article.present? ? @article.count_pages_published_by_source : 0
  end

  def envoyer_message
    @request = Request.new(params[:request])
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
    render :action => "index"
  end
  
private

  def create_request
    @request = Request.new
    @request.recipient = params[:commission]
  end

  def load_index
    @contact = Article.find_published('contact', 1, 1)[0]
    @departements = Article.find_published_order_by_title 'departement', 1, 999
  end
end