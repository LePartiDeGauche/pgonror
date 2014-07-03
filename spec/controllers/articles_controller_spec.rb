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
describe ArticlesController do
  render_views

  context "visitors" do
    it "index (no access)" do
      get :index
      response.should_not be_success
      flash[:alert].should_not be_nil
    end

    it "create (no access)" do
      post :create, :article => {
        :category => "inter",
        :title => "Article 1"
      }
      response.should_not be_success
      flash[:alert].should_not be_nil
    end

    it "update (no access)" do
      article = FactoryGirl.create(:article)
      id = article.id
      post :update,
        :id => article.id,
        :article => { :status => Article::ONLINE }
      response.should_not be_success
      flash[:alert].should_not be_nil
    end

    it "destroy (no access)" do
      article = FactoryGirl.create(:article)
      id = article.id
      delete :destroy, :id => article.id
      response.should_not be_success
      flash[:alert].should_not be_nil
      article = Article.where('id = ?', id).first
      article.should_not be_nil
    end
  end

  context "user not publisher" do
    login_user(:user)

    it "index (no access)" do
      get :index
      response.should_not be_success
      flash[:alert].should_not be_nil
    end

    it "create (no access)" do
      post :create, :article => {
        :category => "inter",
        :title => "Article 1"
      }
      response.should_not be_success
      flash[:alert].should_not be_nil
    end

    it "update (no access)" do
      article = FactoryGirl.create(:article)
      id = article.id
      post :update,
        :id => article.id,
        :article => { :status => Article::ONLINE }
      response.should_not be_success
      flash[:alert].should_not be_nil
    end

    it "destroy (no access)" do
      article = FactoryGirl.create(:article)
      id = article.id
      delete :destroy, :id => article.id
      response.should_not be_success
      flash[:alert].should_not be_nil
      article = Article.where('id = ?', id).first
      article.should_not be_nil
    end
  end

  context "publishers with no authorization" do
    login_user(:publisher)

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

    it "index (log)" do
      5.times {
        FactoryGirl.create(:article)
        article = FactoryGirl.create(:article, :category => 'dossier')
        article.status = Article::ONLINE
        article.save!
      }
      get :index, :log => true
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
      get :search, :search => "article"
      response.should be_success
    end

    it "panel_search" do
      5.times {
        FactoryGirl.create(:article)
        article = FactoryGirl.create(:article, :category => 'dossier')
        article.status = Article::ONLINE
        article.save!
      }
      get :panel_search, :search => "article"
      response.should be_success
    end

    it "panel_search_page" do
      5.times {
        FactoryGirl.create(:article)
        article = FactoryGirl.create(:article, :category => 'dossier')
        article.status = Article::ONLINE
        article.save!
      }
      get :panel_search_page, :search => "article"
      response.should be_success
    end

    it "show" do
      article = FactoryGirl.create(:article)
      article.create_audit!(article.status, article.updated_by, "spec")
      get :show, :id => article.id
      response.should be_success
      response.should render_template('show')
      expect(assigns(:article).title).to be == article.title
    end

    it "new (no access)" do
      get :new, :category => "inter"
      response.should render_template('index')
    end

    it "edit" do
      article = FactoryGirl.create(:article)
      get :edit, :id => article.id
      response.should be_success
      response.should render_template('edit')
    end

    it "change_status (no access)" do
      article = FactoryGirl.create(:article)
      get :edit, :id => article.id, :modifier => "change_status"
      response.should be_success
      response.should render_template('change_status')
    end

    it "change_category (no access)" do
      article = FactoryGirl.create(:article, :category => 'edito')
      get :edit, :id => article.id, :modifier => "change_category"
      response.should be_success
      response.should render_template('change_category')
    end

    it "change_image_options (no access)" do
      article = FactoryGirl.create(:article)
      get :edit, :id => article.id, :modifier => "change_image_options"
      response.should be_success
      response.should render_template('change_image_options')
    end

    it "create with no data (no access)" do
      FactoryGirl.create(:administrator)
      post :create
      response.should render_template('error')
    end

    it "create with bare minimum data (no access)" do
      post :create, :article => {
        :category => "inter",
        :title => "Article 1"
      }
      response.should render_template('new')
      flash[:notice].should be_nil
    end

    it "update (change status, no access)" do
      article = FactoryGirl.create(:article)
      id = article.id
      post :update,
        :id => article.id,
        :modifier => "change_status",
        :article => { :status => Article::ONLINE }
      response.should render_template('index')
      flash[:notice].should_not be_nil
      article = Article.where('id = ?', id).first
      article.should_not be_nil
      article.status.should be_nil
    end

    it "update (change category, no access)" do
      article = FactoryGirl.create(:article, :category => 'dossier')
      id = article.id
      post :update,
        :id => article.id,
        :modifier => "change_category",
        :article => { :category => 'inter' }
      response.should render_template('index')
      flash[:notice].should_not be_nil
      article = Article.where('id = ?', id).first
      article.should_not be_nil
      article.category.should be == 'dossier'
    end

    it "update (change image options, no access)" do
      article = FactoryGirl.create(:article)
      id = article.id
      post :update,
        :id => article.id,
        :modifier => "change_image_options",
        :article => { :gravity => Article::SOUTH }
      response.should render_template('index')
      flash[:notice].should_not be_nil
      article = Article.where('id = ?', id).first
      article.should_not be_nil
      article.gravity.should be_nil
    end

    it "destroy (no access)" do
      article = FactoryGirl.create(:article)
      id = article.id
      delete :destroy, :id => article.id
      response.should_not be_success
      flash[:alert].should_not be_nil
      article = Article.where('id = ?', id).first
      article.should_not be_nil
    end
  end

  context "publishers with authorization" do
    login_user(:publisher, "inter", "dossier")

    it "new" do
      get :new, :category => "inter"
      response.should render_template('new')
    end

    it "new_child" do
      parent = FactoryGirl.create(:article_directory)
      get :new_child, :category => "inter", :parent_id => parent.id
      response.should render_template('new')
    end

    it "create with no data (no access)" do
      FactoryGirl.create(:administrator)
      post :create
      response.should render_template('error')
    end

    it "create with missing data" do
      title = "Article " + Time.now.to_s
      post :create,
           :published_at => I18n.l(Date.today),
           :expired_at => I18n.l(Date.today + 99.years),
           :article => {
             :category => "inter"
           }
      response.should render_template('new')
      flash[:notice].should be_nil
    end

    it "create with incorrect data" do
      title = "Article " + Time.now.to_s
      post :create,
           :published_at => "1234567",
           :expired_at => "2345678",
           :article => {
             :category => "inter",
             :title => title
           }
      article = Article.where('title = ?', title).first
      article.should be_nil
      response.should render_template('new')
      flash[:notice].should be_nil
    end

    it "create with bare minimum data" do
      title = "Article " + Time.now.to_s
      post :create,
           :published_at => I18n.l(Date.today),
           :expired_at => I18n.l(Date.today + 99.years),
           :article => {
             :category => "inter",
             :title => title
           }
      article = Article.where('title = ?', title).first
      article.should_not be_nil
      response.should redirect_to(article)
      expect(assigns(:article).title).to be == title
      flash[:notice].should_not be_nil
    end

    it "create with many data" do
      title = "Article " + Time.now.to_s
      post :create,
           :published_at => I18n.l(Date.today),
           :expired_at => I18n.l(Date.today + 99.years),
           :article => {
             :category => "inter",
             :heading => "Super surtitre",
             :title => title,
             :signature => "Moi",
             :content => "<p>Contenu de l'article</p>" * 15
           }
      article = Article.where('title = ?', title).first
      article.should_not be_nil
      response.should redirect_to(article)
      expect(assigns(:article).title).to be == title
      flash[:notice].should_not be_nil
    end

    it "headings" do
      article = FactoryGirl.create(:article)
      get :headings, :format => :json
      response.should be_success
    end

    it "signatures" do
      article = FactoryGirl.create(:article)
      get :signatures, :format => :json
      response.should be_success
    end

    it "directories" do
      article = FactoryGirl.create(:article_directory)
      get :directories, :format => :json
      response.should be_success
    end

    it "update with incorrect data" do
      article = FactoryGirl.create(:article)
      id = article.id
      post :update,
        :id => article.id,
        :published_at => I18n.l(Date.today),
        :expired_at => I18n.l(Date.today + 99.years),
        :article => {
          :category => "inter",
          :title => ""
        }
      response.should render_template('edit')
      flash[:notice].should be_nil
    end

    it "update" do
      article = FactoryGirl.create(:article)
      id = article.id
      title = "Article " + Time.now.to_s
      post :update,
        :id => article.id,
        :published_at => I18n.l(Date.today),
        :expired_at => I18n.l(Date.today + 99.years),
        :article => {
          :category => "inter",
          :heading => "Super surtitre",
          :title => title,
          :signature => "Moi",
          :content => "<p>Contenu de l'article</p>" * 15
        }
      response.should redirect_to(article)
      expect(assigns(:article).title).to be == title
      flash[:notice].should_not be_nil
      article = Article.where('id = ?', id).first
      article.should_not be_nil
      article.title.should be == title
    end

    it "update (change status)" do
      article = FactoryGirl.create(:article)
      id = article.id
      post :update,
        :id => article.id,
        :modifier => "change_status",
        :article => { :status => Article::ONLINE }
      response.should redirect_to(article)
      flash[:notice].should_not be_nil
      article = Article.where('id = ?', id).first
      article.should_not be_nil
      article.status.should be == Article::ONLINE
    end

    it "update (change category)" do
      article = FactoryGirl.create(:article, :category => 'dossier')
      id = article.id
      post :update,
        :id => article.id,
        :modifier => "change_category",
        :article => { :category => 'inter' }
      response.should redirect_to(article)
      flash[:notice].should_not be_nil
      article = Article.where('id = ?', id).first
      article.should_not be_nil
      article.category.should be == 'inter'
    end

    it "update (change image options)" do
      article = FactoryGirl.create(:article)
      id = article.id
      post :update,
        :id => article.id,
        :modifier => "change_image_options",
        :article => { :gravity => Article::SOUTH }
      response.should redirect_to(article)
      flash[:notice].should_not be_nil
      article = Article.where('id = ?', id).first
      article.should_not be_nil
      article.gravity.should be == Article::SOUTH
    end

    it "destroy (no access)" do
      article = FactoryGirl.create(:article)
      id = article.id
      delete :destroy, :id => article.id
      response.should_not be_success
      flash[:alert].should_not be_nil
      article = Article.where('id = ?', id).first
      article.should_not be_nil
    end
  end

  context "super users with authorization" do
    login_user(:super_user, "inter")

    it "destroy" do
      article = FactoryGirl.create(:article)
      id = article.id
      delete :destroy, :id => article.id
      response.should be_success
      response.should render_template('index')
      flash[:notice].should_not be_nil
      article = Article.where('id = ?', id).first
      article.should be_nil
    end
  end
end