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
class PermissionsController < ApplicationController
  before_filter :authenticate_user!
  before_filter :authenticate_administrator!

  def index
    @user = User.find(params[:user_id])
    if @user.present?
      redirect_to(@user, :only_path => true)
    else
      render :action => "new"
    end
  end

  def new
    @user = User.find(params[:user_id])
    if @user.present?
      @permission = @user.permissions.new
    end
  end

  def create
    @user = User.find(params[:user_id])
    if @user.present?
      @permission = @user.permissions.new(params[:permission])
      @permission.created_by = current_user.email
      @permission.updated_by = current_user.email
      if @permission.save
        flash[:notice] = t('action.permission.created')
        redirect_to(@user, :only_path => true)
      else
        render :action => "new"
      end
    end
  end

  def edit
    @permission = Permission.find(params[:id])
    if @permission.present?
      @user = @permission.user
    end 
  end

  def update
    @permission = Permission.find(params[:id])
    if @permission.present?
      @user = @permission.user
      @permission.updated_by = current_user.email
      if @permission.update_attributes(params[:permission])
        flash[:notice] = t('action.permission.updated')
        redirect_to(@user, :only_path => true)
      else
        render :action => "edit"
      end
    end 
  end

  def destroy
    @permission = Permission.find(params[:id])
    if @permission.present?
      @user = @permission.user
      @permission.destroy
      flash[:notice] = t('action.permission.deleted')
      redirect_to(@user, :only_path => true)
    end 
  end
end