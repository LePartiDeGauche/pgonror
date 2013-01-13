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
describe PhotosController do
  render_views

  context "visitors" do
    it "index" do
      2.times {
        diaporama = FactoryGirl.create(:article, :category => 'diaporama')
        diaporama.status = Article::ONLINE
        diaporama.save!
        file = File.open("#{Rails.root}/spec/datafiles/PG-FDG.png")
        article = FactoryGirl.create(:article_image, :title => nil, :image => file, :parent_id => diaporama.id)
        article.status = Article::ONLINE
        article.save!
      }
      get :index
      response.should render_template('index')
    end

    it "diaporama" do
      diaporama = FactoryGirl.create(:article, :category => 'diaporama')
      diaporama.status = Article::ONLINE
      diaporama.save!
      file = File.open("#{Rails.root}/spec/datafiles/PG-FDG.png")
      article = FactoryGirl.create(:article_image, :title => nil, :image => file, :parent_id => diaporama.id)
      article.status = Article::ONLINE
      article.save!
      get :diaporama, :uri => diaporama.uri
      response.should be_success
    end
  end
end