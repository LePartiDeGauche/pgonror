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
class ContactController < ApplicationController
  before_filter :find_article, :only => [:departement]
  before_filter :load_index

  caches_action :index, :layout => false, :if => Proc.new { params[:commission].blank? and not user_signed_in? }

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
      format.html { render :action => "index" }
    end
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