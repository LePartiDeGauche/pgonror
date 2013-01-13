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
describe MiliterController do
  render_views
  before(:each) do
    article = FactoryGirl.create(:article, :category => 'campagne')
    article.status = Article::ONLINE
    article.save!
    3.times {
      article = FactoryGirl.create(:article_event)
      article.status = Article::ONLINE
      article.save!
      article = FactoryGirl.create(:article, :category => 'tract')
      article.status = Article::ONLINE
      article.save!
      article = FactoryGirl.create(:article, :category => 'affiche')
      article.status = Article::ONLINE
      article.save!
      article = FactoryGirl.create(:article, :category => 'kit')
      article.status = Article::ONLINE
      article.save!
    }
  end

  context "visitors" do
    it "index" do
      get :index
      response.should render_template('index')
    end

    it "rss" do
      5.times {
        article = FactoryGirl.create(:article_event)
        article.status = Article::ONLINE
        article.save!
      }
      get :rss, :format => :xml
      response.should be_success
    end

    it "agenda" do
      get :agenda
      response.should be_success
    end

    it "evenement" do
      article = FactoryGirl.create(:article_event)
      article.status = Article::ONLINE
      article.save!
      get :evenement, :uri => article.uri
      response.should be_success
    end

    it "tracts" do
      get :tracts
      response.should be_success
    end

    it "tract" do
      article = FactoryGirl.create(:article, :category => 'tract')
      article.status = Article::ONLINE
      article.save!
      get :tract, :uri => article.uri
      response.should be_success
    end

    it "affiches" do
      get :affiches
      response.should be_success
    end

    it "affiche" do
      article = FactoryGirl.create(:article, :category => 'affiche')
      article.status = Article::ONLINE
      article.save!
      get :affiche, :uri => article.uri
      response.should be_success
    end

    it "kits" do
      get :kits
      response.should be_success
    end

    it "kit" do
      article = FactoryGirl.create(:article, :category => 'kit')
      article.status = Article::ONLINE
      article.save!
      get :kit, :uri => article.uri
      response.should be_success
    end

    it "inscription with data" do
      FactoryGirl.create(:user, :notification_subscription => true)
      post :inscription, :subscription => {
        :first_name => "Prénom",
        :last_name => "Nom",
        :email => "me@nowhere.com"
      }
      response.should render_template('index')
      flash[:notice].should_not be_nil
    end
  end
end