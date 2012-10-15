# encoding: utf-8
# PGonror is the corporate web site framework of Le Parti de Gauche based on Ruby on Rails.
# 
# Copyright (C) 2012 Le Parti de Gauche
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
  describe "Routage" do

    it "routes to #index" do
      get("/articles").should route_to("articles#index")
    end

    it "routes to #new" do
      get("/articles/new").should route_to("articles#new")
    end

    it "routes to #show" do
      get("/articles/1").should route_to("articles#show", :id => "1")
    end

    it "routes to #edit" do
      get("/articles/1/edit").should route_to("articles#edit", :id => "1")
    end

    it "routes to #create" do
      post("/articles").should route_to("articles#create")
    end

    it "routes to #update" do
      put("/articles/1").should route_to("articles#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/articles/1").should route_to("articles#destroy", :id => "1")
    end

  end
end
