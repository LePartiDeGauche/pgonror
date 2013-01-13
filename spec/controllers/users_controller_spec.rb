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
describe UsersController do
  render_views

  context "visitors" do
    it "index (no access)" do
      get :index
      response.should_not be_success
      flash[:alert].should_not be_nil
    end

    it "search (no access)" do
      user = FactoryGirl.create(:user)
      get :search, :search => "me"
      response.should_not be_success
      flash[:alert].should_not be_nil
    end

    it "show (no access)" do
      user = FactoryGirl.create(:user)
      get :show, :id => user.id
      response.should_not be_success
      flash[:alert].should_not be_nil
    end

    it "edit (no access)" do
      user = FactoryGirl.create(:user)
      get :edit, :id => user.id
      response.should_not be_success
      flash[:alert].should_not be_nil
    end

    it "update (no access)" do
      user = FactoryGirl.create(:user)
      post :update,
        :id => user.id,
        :user => { :access_level => "reserved" }
      response.should_not be_success
      flash[:alert].should_not be_nil
    end

    it "destroy (no access)" do
      user = FactoryGirl.create(:user)
      id = user.id
      delete :destroy, :id => id
      response.should_not be_success
      flash[:alert].should_not be_nil
      user = User.where('id = ?', id).first
      user.should_not be_nil
    end
  end

  context "administrator" do
    login_user(:administrator)

    it "show" do
      user = FactoryGirl.create(:user)
      get :show, :id => user.id
      response.should be_success
      response.should render_template('show')
      expect(assigns(:user).email).to be == user.email
    end

    it "edit" do
      user = FactoryGirl.create(:user)
      get :edit, :id => user.id
      response.should be_success
      response.should render_template('edit')
    end

    it "search" do
      user = FactoryGirl.create(:user)
      get :search, :search => "me"
      response.should be_success
      response.should render_template('search_list')
    end

    it "update" do
      user = FactoryGirl.create(:user)
      id = user.id
      post :update,
        :id => user.id,
        :user => {
          :email => user.email,
          :access_level => "reserved"
        }
      response.should redirect_to(user)
      flash[:notice].should_not be_nil
      user = User.where('id = ?', id).first
      user.should_not be_nil
      user.access_level.should be == "reserved"
    end

    it "destroy" do
      user = FactoryGirl.create(:user)
      id = user.id
      delete :destroy, :id => id
      response.should be_success
      response.should render_template('index')
      flash[:notice].should_not be_nil
      user = User.where('id = ?', id).first
      user.should be_nil
    end
  end
end