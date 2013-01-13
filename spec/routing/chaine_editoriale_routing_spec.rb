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
require "spec_helper"
describe ArticlesController do
  describe "Articles" do
    it "/" do
      get("/articles").should route_to("articles#index")
    end

    it "/new" do
      get("/articles/new").should route_to("articles#new")
    end

    it "/show" do
      get("/articles/1").should route_to("articles#show", :id => "1")
    end

    it "/edit" do
      get("/articles/1/edit").should route_to("articles#edit", :id => "1")
    end

    it "/create" do
      post("/articles").should route_to("articles#create")
    end

    it "/update" do
      put("/articles/1").should route_to("articles#update", :id => "1")
    end

    it "/destroy" do
      delete("/articles/1").should route_to("articles#destroy", :id => "1")
    end

    it "/search" do
      get("/articles/search").should route_to("articles#search")
    end

    it "/panel_search" do
      get("/articles/panel_search").should route_to("articles#panel_search")
    end

    it "/panel_search_page" do
      get("/articles/panel_search_page").should route_to("articles#panel_search_page")
    end

    it "/new_child" do
      get("/articles/new_child").should route_to("articles#new_child")
    end

    it "/headings" do
      get("/articles/headings").should route_to("articles#headings")
    end

    it "/signatures" do
      get("/articles/signatures").should route_to("articles#signatures")
    end

    describe "Tags" do
      it "/" do
        get("/articles/1/tags").should route_to("tags#index", :article_id => "1")
      end
  
      it "/new" do
        get("/articles/1/tags/new").should route_to("tags#new", :article_id => "1")
      end
  
      it "/create" do
        post("/articles/1/tags").should route_to("tags#create", :article_id => "1")
      end
  
      it "/destroy" do
        delete("/articles/1/tags/1").should route_to("tags#destroy", :article_id => "1", :id => "1")
      end
    end
  end

  describe "Tags" do
    it "/" do
      get("/tags").should route_to("tags#index")
    end

    it "/new" do
      get("/tags/new").should route_to("tags#new")
    end

    it "/create" do
      post("/tags").should route_to("tags#create")
    end

    it "/destroy" do
      delete("/tags/1").should route_to("tags#destroy", :id => "1")
    end
  end
end