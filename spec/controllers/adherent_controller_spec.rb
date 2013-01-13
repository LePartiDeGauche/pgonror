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
describe AdherentController do
  render_views

  context "visitors" do
    it "index (no access)" do
      get :index
      response.should_not be_success
      flash[:alert].should_not be_nil
    end

    it "search (no access)" do
      get :search
      response.should_not be_success
      flash[:alert].should_not be_nil
    end

    it "article (no access)" do
      get :article, :id => "aaa"
      response.should_not be_success
      flash[:alert].should_not be_nil
    end
  end

  context "member" do
    login_user(:member)

    it "index" do
      5.times {
        FactoryGirl.create(:article)
        article = FactoryGirl.create(:article, :category => 'dossier')
        article.status = Article::ONLINE
        article.save!
      }
      get :index
      response.should be_success
      response.should render_template('index')
    end

    it "search" do
      5.times {
        FactoryGirl.create(:article)
        article = FactoryGirl.create(:article, :category => 'dossier')
        article.status = Article::ONLINE
        article.save!
      }
      get :search, :search => "search_list"
      response.should be_success
    end

    it "article" do
      article = FactoryGirl.create(:article)
      article.status = Article::ONLINE
      article.save!
      get :article, :uri => article.uri
      response.should be_success
      response.should render_template('article')
      expect(assigns(:article).title).to be == article.title
    end
  end
end