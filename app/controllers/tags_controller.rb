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
class TagsController < ApplicationController
  before_filter :authenticate_user!
  before_filter :authenticate_publisher!

  def new
    @article = Article.find(params[:article_id])
    unless @article.nil?
      @tag = @article.tags.new
      @unused_tags = @article.unused_tags
    end
  end

  def index
    @modifier = params[:modifier]
    if "add" == @modifier
      @article = Article.find(params[:article_id])
      unless @article.nil?
        @tag = @article.tags.new
        @tag.tag = params[:tag]
        @tag.created_by = current_user.email
        @tag.updated_by = current_user.email
        Article.create_default_tag @tag.tag, current_user.email
        if @tag.save
          flash[:notice] = t('action.tag.added')
          redirect_to(@article, :only_path => true)
        else
          @unused_tags = @article.unused_tags
          render :action => "new"
        end
      end
    else
      @predefined_tags = Tag.predefined_tags
      @unused_tags = Tag.unused_tags
    end
  end

  def create
    saved = false
    begin
      @article = Article.find(params[:article_id])
      unless @article.nil?
        @tag = @article.tags.new(params[:tag])
        @tag.created_by = current_user.email
        @tag.updated_by = current_user.email
        Article.create_default_tag @tag.tag, current_user.email
        if @tag.save
          saved = true
        end
      end
    rescue ActiveRecord::RecordInvalid => invalid
      log_warning "create", invalid
    end
    if saved
      flash[:notice] = t('action.tag.created')
      redirect_to(@article, :only_path => true)
    else
      @unused_tags = @article.unused_tags
      render :action => "new"
    end
  end

  def destroy
    @tag = Tag.find(params[:id])
    if @tag.present?
      @article = @tag.article
      @tag.delete_all_references if @article.nil?
      @tag.destroy
      flash[:notice] = t('action.tag.deleted')
      unless @article.nil?
        redirect_to(@article, :only_path => true)
      else
        @predefined_tags = Tag.predefined_tags
        @unused_tags = Tag.unused_tags
        render :action => "index"
      end
    end 
  end
end