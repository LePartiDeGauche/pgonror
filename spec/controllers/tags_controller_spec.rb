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
describe TagsController do
  render_views

  context "visitors" do
    it "index (no access)" do
      get :index
      response.should_not be_success
      flash[:alert].should_not be_nil
    end

    it "create (no access)" do
      article = FactoryGirl.create(:article)
      post :create, :article => {
        :category => "inter",
        :title => "Article 1"
      }
      response.should_not be_success
      flash[:alert].should_not be_nil
    end

    it "destroy (no access)" do
      Article.create_default_tag("parti de gauche", "spec@lepartidegauche.fr")
      article = FactoryGirl.create(:article, :content => "<p>Article très recherché du Parti de Gauche</p>")
      article.status = Article::ONLINE
      article.save!
      tag = Tag.where('article_id = ?', article.id).first
      id = tag.id
      delete :destroy, :id => id
      response.should_not be_success
      flash[:alert].should_not be_nil
      tag = Tag.where('article_id = ?', article.id).first
      tag.should_not be_nil
    end
  end

  context "publishers with authorization" do
    login_user(:publisher, "inter")

    it "index" do
      Article.create_default_tag("parti", "spec@lepartidegauche.fr")
      get :index
      response.should be_success
      flash[:alert].should be_nil
      response.should render_template('index')
    end

    it "index (creationmode)" do
      article = FactoryGirl.create(:article)
      get :index, :modifier => "add", :article_id => article.id, :tag => "parti"
      tag = Tag.where('article_id = ?', article.id).first
      tag.should_not be_nil
      tag.tag.should be == "parti"
      response.should redirect_to(article)
    end

    it "index (creationmode with error)" do
      article = FactoryGirl.create(:article)
      get :index, :modifier => "add", :article_id => article.id
      tag = Tag.where('article_id = ?', article.id).first
      tag.should be_nil
      response.should render_template('new')
    end

    it "new" do
      article = FactoryGirl.create(:article)
      get :new, :article_id => article.id
      response.should render_template('new')
    end

    it "create with no data (no access)" do
      post :create
      response.should render_template('error')
    end

    it "create with missing data" do
      article = FactoryGirl.create(:article)
      post :create,
           :article_id => article.id
      response.should render_template('new')
      flash[:notice].should be_nil
    end

    it "create with bare minimum data" do
      article = FactoryGirl.create(:article)
      tag = Time.now.to_s
      post :create,
           :article_id => article.id,
           :tag => { :tag => tag }
      tag = Tag.where('article_id = ?', article.id).first
      tag.should_not be_nil
      tag.tag.should be == tag.tag
      response.should redirect_to(article)
    end

    it "destroy" do
      Article.create_default_tag("parti de gauche", "spec@lepartidegauche.fr")
      article = FactoryGirl.create(:article, :content => "<p>Article très recherché du Parti de Gauche</p>")
      article.status = Article::ONLINE
      article.save!
      tag = Tag.where('article_id = ?', article.id).first
      id = tag.id
      delete :destroy, :id => id
      response.should redirect_to(article)
      flash[:notice].should_not be_nil
      tag = Tag.where('article_id = ?', article.id).first
      tag.should be_nil
    end

    it "destroy predefined tag" do
      Article.create_default_tag("parti de gauche", "spec@lepartidegauche.fr")
      tag = Tag.where('tag = ?', "parti de gauche").first
      id = tag.id
      delete :destroy, :id => id
      response.should render_template('index')
      tag = Tag.where('tag = ?', "parti de gauche").first
      tag.should be_nil
    end
  end
end