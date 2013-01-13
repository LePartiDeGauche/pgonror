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
describe EducpopController do
  render_views
  before(:each) do
    3.times {
      article = FactoryGirl.create(:article, :category => 'date')
      article.status = Article::ONLINE
      article.save!
      article = FactoryGirl.create(:article, :category => 'livre')
      article.status = Article::ONLINE
      article.save!
      article = FactoryGirl.create(:article, :category => 'lecture')
      article.status = Article::ONLINE
      article.save!
      article = FactoryGirl.create(:article, :category => 'revue')
      article.status = Article::ONLINE
      article.save!
    }
  end

  context "visitors" do
    it "index" do
      get :index
      response.should render_template('index')
    end

    it "dates" do
      get :dates
      response.should be_success
    end

    it "date" do
      article = FactoryGirl.create(:article, :category => 'date')
      article.status = Article::ONLINE
      article.save!
      get :date, :uri => article.uri
      response.should be_success
    end

    it "librairie" do
      get :librairie
      response.should be_success
    end

    it "livre" do
      article = FactoryGirl.create(:article, :category => 'livre')
      article.status = Article::ONLINE
      article.save!
      get :livre, :uri => article.uri
      response.should be_success
    end

    it "lectures" do
      get :lectures
      response.should be_success
    end

    it "lecture" do
      article = FactoryGirl.create(:article, :category => 'lecture')
      article.status = Article::ONLINE
      article.save!
      get :lecture, :uri => article.uri
      response.should be_success
    end

    it "revues" do
      get :revues
      response.should be_success
    end

    it "revue" do
      article = FactoryGirl.create(:article, :category => 'revue')
      article.status = Article::ONLINE
      article.save!
      get :revue, :uri => article.uri
      response.should be_success
    end
  end
end