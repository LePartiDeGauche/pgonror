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
describe VudailleursController do
  render_views
  before(:each) do
    3.times {
      article = FactoryGirl.create(:article, :category => 'web')
      article.status = Article::ONLINE
      article.save!
      article = FactoryGirl.create(:article, :category => 'directblog')
      article.status = Article::ONLINE
      article.save!
      article = FactoryGirl.create(:article, :category => 'blog')
      article.status = Article::ONLINE
      article.save!
    }
  end

  context "visitors" do
    it "index" do
      get :index
      response.should render_template('index')
    end

    it "articlesweb" do
      get :articlesweb
      response.should be_success
    end

    it "articleweb" do
      article = FactoryGirl.create(:article, :category => 'web')
      article.status = Article::ONLINE
      article.save!
      get :articleweb, :uri => article.uri
      response.should be_success
    end

    it "articlesblog" do
      get :articlesblog
      response.should be_success
    end

    it "articleblog" do
      article = FactoryGirl.create(:article, :category => 'directblog')
      article.status = Article::ONLINE
      article.save!
      get :articleblog, :uri => article.uri
      response.should be_success
    end

    it "blogs" do
      get :blogs
      response.should be_success
    end

    it "blog" do
      blog = FactoryGirl.create(:article, :category => 'blog')
      blog.status = Article::ONLINE
      blog.save!
      5.times {
        article = FactoryGirl.create(:article, :category => 'directblog', :source_id => blog.id)
        article.status = Article::ONLINE
        article.save!
      }
      get :blog, :uri => blog.uri
      response.should be_success
      get :blog, :uri => blog.uri, :partial => true
      response.should be_success
    end

    it "envoyer_message with no data" do
      post :envoyer_message
      response.should render_template('articlesweb')
      flash[:notice].should be_nil
    end

    it "envoyer_message with missing data" do
      post :envoyer_message, :request => {
        :first_name => "Prénom",
        :last_name => "Nom"
      }
      response.should render_template('articlesweb')
      flash[:notice].should be_nil
    end

    it "valider_adhesion with data" do
      FactoryGirl.create(:user, :notification_message => true)
      post :envoyer_message, :request => {
        :recipient => "X",
        :first_name => "Prénom",
        :last_name => "Nom",
        :email => "me@nowhere.com",
        :address => "Avenue de la République",
        :zip_code => "75000",
        :city => "Paris",
        :phone => "0102030405",
        :comment => "Merci de me faire parvenir des informations immédiatement tout de suite maintenant."
      }
      response.should render_template('articlesweb')
      flash[:notice].should_not be_nil
    end
  end
end