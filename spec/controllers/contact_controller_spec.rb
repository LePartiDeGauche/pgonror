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
describe ContactController do
  render_views
  before(:each) do
    article = FactoryGirl.create(:article, :category => 'contact')
    article.status = Article::ONLINE
    article.save!
    5.times {
      article = FactoryGirl.create(:article, :category => 'departement')
      article.status = Article::ONLINE
      article.save!
    }
  end

  context "visitors" do
    it "index" do
      get :index
      response.should render_template('index')
    end

    it "departement" do
      article = FactoryGirl.create(:article, :category => 'departement')
      article.status = Article::ONLINE
      article.save!
      get :departement, :uri => article.uri
      response.should be_success
    end

    it "envoyer_message with no data" do
      post :envoyer_message
      response.should render_template('index')
      flash[:notice].should be_nil
    end

    it "envoyer_message with missing data" do
      post :envoyer_message, :request => {
        :first_name => "Prénom",
        :last_name => "Nom"
      }
      response.should render_template('index')
      flash[:notice].should be_nil
    end

    it "valider_adhesion with data" do
      FactoryGirl.create(:user, :notification_message => true)
      article = FactoryGirl.create(:article_email)
      article.status = Article::ONLINE
      article.save!
      post :envoyer_message, :request => {
        :recipient => article.uri,
        :first_name => "Prénom",
        :last_name => "Nom",
        :email => "me@nowhere.com",
        :address => "Avenue de la République",
        :zip_code => "75000",
        :city => "Paris",
        :phone => "0102030405",
        :comment => "Merci de me faire parvenir des informations immédiatement tout de suite maintenant."
      }
      response.should render_template('index')
      flash[:notice].should_not be_nil
    end
  end
end