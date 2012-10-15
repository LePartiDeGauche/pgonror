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
class AdherentController < ApplicationController
  before_filter :authenticate_user!
  before_filter :authenticate_access_reserved!
  before_filter :find_article, :only => [:article]

  def index
    prepare_index
    reset_backtrace
    save_backtrace
  end

  def search
    prepare_index
    render :partial => "search_list"
  end

  def article
    prepare_index
    save_backtrace
  end

private

  def prepare_index
    @articles = Article.find_by_criteria({:status => Article::ONLINE, 
                                          :category => params[:category], 
                                          :parent => params[:parent], 
                                          :search => params[:search],
                                          :access_level_reserved => true}, @page)
    @pages = Article.count_pages_by_criteria({:status => Article::ONLINE, 
                                              :category => params[:category], 
                                              :parent => params[:parent], 
                                              :search => params[:search],
                                              :access_level_reserved => true})
    @categories_online = Article.find_by_status_group_by_category Article::ONLINE, :reserved
    session[:category] = params[:category]
    session[:parent] = params[:parent]
    session[:search] = params[:search]
    session[:page] = @page
  end
end