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
describe ActualitesController do
  render_views
  before(:each) do
    3.times {
      article = FactoryGirl.create(:article, :category => 'edito')
      article.status = Article::ONLINE
      article.save!
      article = FactoryGirl.create(:article, :category => 'actu')
      article.status = Article::ONLINE
      article.save!
      article = FactoryGirl.create(:article, :category => 'com')
      article.status = Article::ONLINE
      article.save!
      article = FactoryGirl.create(:article, :category => 'inter')
      article.status = Article::ONLINE
      article.save!
      article = FactoryGirl.create(:article, :category => 'dossier')
      article.status = Article::ONLINE
      article.save!
    }
  end

  context "visitors" do
    it "index" do
      get :index
      response.should render_template('index')
    end

    it "editos" do
      get :editos
      response.should be_success
    end

    it "edito" do
      article = FactoryGirl.create(:article, :category => 'edito')
      article.status = Article::ONLINE
      article.save!
      get :edito, :uri => article.uri
      response.should be_success
    end

    it "actualites" do
      get :actualites
      response.should be_success
    end

    it "actualite" do
      article = FactoryGirl.create(:article, :category => 'actu')
      article.status = Article::ONLINE
      article.save!
      get :actualite, :uri => article.uri
      response.should be_success
    end

    it "communiques" do
      get :communiques
      response.should be_success
    end

    it "communique" do
      article = FactoryGirl.create(:article, :category => 'com')
      article.status = Article::ONLINE
      article.save!
      get :communique, :uri => article.uri
      response.should be_success
    end

    it "tout_international" do
      get :tout_international
      response.should be_success
    end

    it "international" do
      article = FactoryGirl.create(:article, :category => 'inter')
      article.status = Article::ONLINE
      article.save!
      get :international, :uri => article.uri
      response.should be_success
    end

    it "dossiers" do
      get :dossiers
      response.should be_success
    end

    it "dossier" do
      article = FactoryGirl.create(:article, :category => 'dossier')
      article.status = Article::ONLINE
      article.save!
      get :dossier, :uri => article.uri
      response.should be_success
    end
  end
end