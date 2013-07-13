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
class UsersController < ApplicationController
  before_filter :authenticate_user!
  before_filter :authenticate_administrator!

  def index
  end

  def search
    @users = User.find_like_email(@search)
    render :partial => "search_list"
  end

  def show
    @user = User.find_by_id(params[:id])
  end

  def edit
    @user = User.find_by_id(params[:id])
  end

  def update
    saved = false
    @user = User.find_by_id(params[:id])
    unless @user.nil?
      begin
        @user.transaction do
          @user.updated_by = current_user.email
          @user.update_attributes(params[:user])
          saved = true
        end
      end
    end
    if saved
      flash[:notice] = t('action.user.updated')
      redirect_to(@user)
    else
      render :action => "edit"
    end
  end

  def destroy
    saved = false
    @user = User.find_by_id(params[:id])
    unless @user.nil?
      begin
        @user.transaction do
          @user.destroy
          saved = true
        end
      end
    end
    flash[:notice] = t('action.user.deleted') if saved
    render :action => :index
  end
end