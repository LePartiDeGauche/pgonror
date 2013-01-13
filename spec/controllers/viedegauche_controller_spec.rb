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
describe ViedegaucheController do
  render_views
  before(:each) do
    3.times {
      article = FactoryGirl.create(:article, :category => 'articlevdg')
      article.status = Article::ONLINE
      article.save!
      article = FactoryGirl.create(:article, :category => 'vdg')
      article.status = Article::ONLINE
      article.save!
    }
  end

  context "visitors" do
    it "index" do
      get :index
      response.should render_template('index')
    end

    it "article" do
      article = FactoryGirl.create(:article, :category => 'articlevdg')
      article.status = Article::ONLINE
      article.save!
      get :article, :uri => article.uri
      response.should be_success
    end

    it "journauxvdg" do
      get :journauxvdg
      response.should be_success
    end

    it "journalvdg" do
      article = FactoryGirl.create(:article, :category => 'vdg')
      article.status = Article::ONLINE
      article.save!
      get :journalvdg, :uri => article.uri
      response.should be_success
    end
  end
end