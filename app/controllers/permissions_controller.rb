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
class PermissionsController < ApplicationController
  before_action :authenticate_user!
  before_action :authenticate_administrator!

  def index
    @user = User.find_by_id(params[:user_id])
    redirect_to(@user, :only_path => true) if @user.present?
  end

  def new
    @user = User.find_by_id(params[:user_id])
    @permission = @user.permissions.new if @user.present?
  end

  def create
    @user = User.find_by_id(params[:user_id])
    if @user.present?
      @permission = @user.permissions.new(permission_parameters)
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
    @permission = Permission.find_by_id(params[:id])
    if @permission.present?
      @user = @permission.user
    end 
  end

  def update
    @permission = Permission.find_by_id(params[:id])
    if @permission.present?
      @user = @permission.user
      @permission.updated_by = current_user.email
      if @permission.update_attributes(permission_parameters)
        flash[:notice] = t('action.permission.updated')
        redirect_to(@user, :only_path => true)
      else
        render :action => "edit"
      end
    end 
  end

  def destroy
    @permission = Permission.find_by_id(params[:id])
    if @permission.present?
      @user = @permission.user
      @permission.destroy
      flash[:notice] = t('action.permission.deleted')
      redirect_to(@user, :only_path => true)
    end 
  end

private

  # Returns the parameters that are allowed for mass-update.
  def permission_parameters
    return nil if params[:permission].nil?
    params.require(:permission).permit(:user_id,
                                       :source_id,
                                       :category,
                                           :authorization,
                                           :notification_level)
  end
end