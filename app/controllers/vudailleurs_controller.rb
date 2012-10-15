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
class VudailleursController < ApplicationController
  before_filter :find_article, :only => [:articleweb, :articleblog, :blog]
  before_filter :load_side_articles, :only => [:articleweb, :articlesweb,
                                               :articleblog, :articlesblog,
                                               :blogs, :blog,
                                               :envoyer_message]

  caches_action :index, :layout => false
  caches_action :articlesweb, :layout => false, :if => Proc.new { @page == 1 }
  caches_action :articlesblog, :layout => false, :if => Proc.new { @page == 1 }

  def index
    @articlesweb = Article.find_published 'web', 1, 3
    @articlesblog = Article.find_published 'directblog', 1, 10
  end
  
  def articleweb
    create_request
  end

  def articlesweb
    create_request
    @pages = Article.count_pages_published 'web'
    @articles = Article.find_published 'web', @page
  end
  
  def articleblog
  end
  
  def articlesblog
    @pages = Article.count_pages_published 'directblog'
    @articles = Article.find_published 'directblog', @page
    @blogs = Article.find_published_order_by_title 'blog', 1, 10 
  end
  
  def blogs
    @pages = Article.count_pages_published 'blog'
    @blogs = Article.find_published_order_by_title 'blog', @page 
  end
  
  def blog
    @attached_articles = @article.present? ? @article.find_published_by_source(@page) : nil
    @pages = @article.present? ? @article.count_pages_published_by_source : 0
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
    rescue Exception => invalid
      log_error "envoyer_message", invalid
    end
    respond_to do |format|
      if saved
        flash.now[:notice] = t('action.request.created')
        recipients = nil
        if @request.recipient.present?
          recipient = Article::find_by_uri(@request.recipient)
          if recipient.present? and recipient.email.present?
            recipients = [recipient.email]
          end
        end
        recipients = User.notification_recipients("notification_message") if recipients.nil?
        if not recipients.empty?
          Notification.notification_message(@request.email, 
                                            recipients.join(', '),
                                            t('mailer.notification_message_subject'),
                                            @request.first_name,
                                            @request.last_name, 
                                            @request.email, 
                                            @request.address, 
                                            @request.zip_code,
                                            @request.city, 
                                            @request.phone,
                                            @request.comment).deliver
        end
        Receipt.receipt_message(Devise.mailer_sender, 
                                @request.email,
                                t('mailer.receipt_message_subject'),
                                @request.first_name,
                                @request.last_name,
                                url_for(:controller => :accueil,
                                        :action => :index,
                                        :only_path => false)).deliver
        create_request
      end
      @pages = Article.count_pages_published 'web'
      @articles = Article.find_published 'web', @page
      format.html { render :action => "articlesweb" }
    end
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