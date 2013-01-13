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
describe VideosController do
  render_views
  before(:each) do
    3.times {
      article = FactoryGirl.create(:article, :category => 'video')
      article.status = Article::ONLINE
      article.save!
      article = FactoryGirl.create(:article, :category => 'videoevenement')
      article.status = Article::ONLINE
      article.save!
      article = FactoryGirl.create(:article, :category => 'media')
      article.status = Article::ONLINE
      article.save!
      article = FactoryGirl.create(:article, :category => 'videoagitprop')
      article.status = Article::ONLINE
      article.save!
      article = FactoryGirl.create(:article, :category => 'videoeduc')
      article.status = Article::ONLINE
      article.save!
      article = FactoryGirl.create(:article, :category => 'encampagne')
      article.status = Article::ONLINE
      article.save!
      article = FactoryGirl.create(:article, :category => 'videoweb')
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
      get :rss, :format => :xml
      response.should be_success
    end

    it "video" do
      article = FactoryGirl.create(:article, :category => 'video')
      article.status = Article::ONLINE
      article.save!
      get :video, :uri => article.uri
      response.should be_success
    end

    it "lateledegauche" do
      get :lateledegauche
      response.should render_template('lateledegauche')
    end

    it "conferences" do
      get :conferences
      response.should be_success
    end

    it "conference" do
      article = FactoryGirl.create(:article, :category => 'conference')
      article.status = Article::ONLINE
      article.save!
      get :conference, :uri => article.uri
      response.should be_success
    end

    it "videospresdechezvous" do
      get :videospresdechezvous
      response.should be_success
    end

    it "presdechezvous" do
      article = FactoryGirl.create(:article, :category => 'videoevenement')
      article.status = Article::ONLINE
      article.save!
      get :presdechezvous, :uri => article.uri
      response.should be_success
    end

    it "medias" do
      get :medias
      response.should be_success
    end

    it "media" do
      article = FactoryGirl.create(:article, :category => 'media')
      article.status = Article::ONLINE
      article.save!
      get :media, :uri => article.uri
      response.should be_success
    end

    it "videosagitprop" do
      get :videosagitprop
      response.should be_success
    end

    it "agitprop" do
      article = FactoryGirl.create(:article, :category => 'videoagitprop')
      article.status = Article::ONLINE
      article.save!
      get :agitprop, :uri => article.uri
      response.should be_success
    end

    it "touteducpop" do
      get :touteducpop
      response.should be_success
    end

    it "educpop" do
      article = FactoryGirl.create(:article, :category => 'videoeduc')
      article.status = Article::ONLINE
      article.save!
      get :educpop, :uri => article.uri
      response.should be_success
    end

    it "videosencampagne" do
      get :videosencampagne
      response.should be_success
    end

    it "encampagne" do
      article = FactoryGirl.create(:article, :category => 'encampagne')
      article.status = Article::ONLINE
      article.save!
      get :encampagne, :uri => article.uri
      response.should be_success
    end

    it "toutweb" do
      get :toutweb
      response.should be_success
    end

    it "web" do
      article = FactoryGirl.create(:article, :category => 'videoweb')
      article.status = Article::ONLINE
      article.save!
      get :web, :uri => article.uri
      response.should be_success
    end
  end
end