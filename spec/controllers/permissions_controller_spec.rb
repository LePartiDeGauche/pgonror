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
require 'spec_helper'
describe PermissionsController do
  render_views

  context "visitors" do
    it "index (no access)" do
      get :index
      response.should_not be_success
      flash[:alert].should_not be_nil
    end

    it "edit (no access)" do
      user = FactoryGirl.create(:user)
      permission = FactoryGirl.create(:permission, :user => user)
      get :edit, :id => permission.id
      response.should_not be_success
      flash[:alert].should_not be_nil
    end

    it "update (no access)" do
      user = FactoryGirl.create(:user)
      permission = FactoryGirl.create(:permission, :user => user)
      post :update,
        :id => permission.id,
        :user => { :access_level => "reserved" }
      response.should_not be_success
      flash[:alert].should_not be_nil
    end

    it "destroy (no access)" do
      user = FactoryGirl.create(:user)
      permission = FactoryGirl.create(:permission, :user => user)
      id = permission.id
      delete :destroy, :id => id
      response.should_not be_success
      flash[:alert].should_not be_nil
      permission = Permission.where('id = ?', id).first
      permission.should_not be_nil
    end
  end

  context "administrator" do
    login_user(:administrator)

    it "index" do
      user = FactoryGirl.create(:user)
      permission = FactoryGirl.create(:permission, :user => user)
      get :index, :user_id => user.id
      response.should redirect_to(user)
    end

    it "new" do
      user = FactoryGirl.create(:user)
      get :new, :user_id => user.id
      response.should render_template('new')
    end

    it "create with missing data" do
      user = FactoryGirl.create(:user)
      post :create,
           :user_id => user.id,
           :permission => {
             :notification_level => Article::NEW
           }
      response.should render_template('new')
      flash[:notice].should be_nil
    end

    it "create" do
      user = FactoryGirl.create(:user)
      post :create,
           :user_id => user.id,
           :permission => {
             :category => "inter",
             :authorization => Permission::PUBLISHER,
             :notification_level => Article::NEW
           }
      response.should redirect_to(user)
      flash[:notice].should_not be_nil
      permission = Permission.where('user_id = ?', user.id).first
      permission.should_not be_nil
      permission.category.should be == "inter"
      permission.authorization.should be == Permission::PUBLISHER
      permission.notification_level.should be == Article::NEW
    end

    it "edit" do
      user = FactoryGirl.create(:user)
      permission = FactoryGirl.create(:permission, :user => user)
      get :edit, :id => permission.id
      response.should be_success
      response.should render_template('edit')
    end

    it "update with incorrect data" do
      user = FactoryGirl.create(:user)
      permission = FactoryGirl.create(:permission, :user => user)
      id = permission.id
      post :update,
        :id => permission.id,
        :permission => {
          :category => ""
        }
      response.should render_template('edit')
      flash[:notice].should be_nil
    end

    it "update" do
      user = FactoryGirl.create(:user)
      permission = FactoryGirl.create(:permission, :user => user)
      id = permission.id
      post :update,
        :id => permission.id,
        :permission => {
          :notification_level => Article::NEW
        }
      response.should redirect_to(user)
      flash[:notice].should_not be_nil
      permission = Permission.where('id = ?', id).first
      permission.should_not be_nil
      permission.notification_level.should be == Article::NEW
    end

    it "destroy" do
      user = FactoryGirl.create(:user)
      permission = FactoryGirl.create(:permission, :user => user)
      id = permission.id
      delete :destroy, :id => id
      response.should redirect_to(user)
      flash[:notice].should_not be_nil
      permission = Permission.where('id = ?', id).first
      permission.should be_nil
    end
  end
end