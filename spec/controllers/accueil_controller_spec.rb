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
describe AccueilController do
  render_views

  context "visitors" do
    it "index" do
      5.times {
        article = FactoryGirl.create(:article)
        article.status = Article::ONLINE
        article.save!
        article = FactoryGirl.create(:article_event)
        article.status = Article::ONLINE
        article.save!
      }
      get :index
      response.should be_success
    end

    it "search" do
      15.times {
        article = FactoryGirl.create(:article)
        article.status = Article::ONLINE
        article.save!
      }
      get :search, :search => 'article'
      response.should be_success
      get :search, :search => 'article', :partial => true, :page => 2
      response.should be_success
    end

    it "legal" do
      article = FactoryGirl.create(:article, :category => 'legal', :content => "Mentions légales")
      article.status = Article::ONLINE
      article.save!
      get :legal
      response.should be_success
    end

    it "agauche" do
      article = FactoryGirl.create(:article, :category => 'presentation_agauche')
      article.status = Article::ONLINE
      article.save!
      get :agauche
      response.should be_success
    end

    it "gavroche" do
      article = FactoryGirl.create(:article, :category => 'presentation_gavroche')
      article.status = Article::ONLINE
      article.save!
      get :gavroche
      response.should be_success
    end

    it "accueil_rss" do
      get :accueil_rss
      response.should be_success
    end

    it "rss" do
      5.times {
        article = FactoryGirl.create(:article)
        article.status = Article::ONLINE
        article.save!
      }
      get :rss, :format => :xml
      response.should be_success
    end

    it "export_txt" do
      5.times {
        article = FactoryGirl.create(:article)
        article.status = Article::ONLINE
        article.save!
      }
      get :export_txt
      response.should be_success
    end

    it "sitemap" do
      get :sitemap, :format => :xml
      response.should be_success
    end

    it "default" do
      get :default, :id => 'a'
      response.should_not be_success
    end
    
    it "default" do
      article = FactoryGirl.create(:article)
      article.status = Article::ONLINE
      article.save!
      get :default, :id => article.id, :format => :pdf
      response.should_not be_success
      get :default, :id => 'aaa', :format => :pdf
      response.should_not be_success
      get :default, :id => article.id
      response.should_not be_success
    end
  end
end