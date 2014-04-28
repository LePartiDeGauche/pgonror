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
describe "Administration" do
  describe "Users" do
    it "/users" do
      get("/administration?type=adherents").should route_to("administration#index", :type => "adherents")
    end

    it "/users/search" do
      get("/administration?type=adherents&search=X").should route_to("administration#index", :type => "adherents", :search => "X")
    end
    
    it "/show" do
      get("/users/1").should route_to("users#show", :id => "1")
    end

    it "/edit" do
      get("/users/1/edit").should route_to("users#edit", :id => "1")
    end

    it "/update" do
      put("/users/1").should route_to("users#update", :id => "1")
    end

    it "/destroy" do
      delete("/users/1").should route_to("users#destroy", :id => "1")
    end

    describe "Permissions" do
      it "/" do
        get("/users/1/permissions").should route_to("permissions#index", :user_id => "1")
      end

      it "/new" do
        get("/users/1/permissions/new").should route_to("permissions#new", :user_id => "1")
      end

      it "/create" do
        post("/users/1/permissions").should route_to("permissions#create", :user_id => "1")
      end

      it "/update" do
        put("/users/1/permissions/1").should route_to("permissions#update", :user_id => "1", :id => "1")
      end

      it "/destroy" do
        delete("/users/1/permissions/1").should route_to("permissions#destroy", :user_id => "1", :id => "1")
      end
    end
  end

  describe "Memberships" do
    it "/administration?type=adherents" do
      get("/administration?type=adherents").should route_to("administration#index", :type => "adherents")
    end

    it "/administration?type=adherents" do
      get("/administration?type=adherents_paye").should route_to("administration#index", :type => "adherents_paye")
    end

    it "/administration?type=adherents" do
      get("/administration?type=adherents_nonabouti").should route_to("administration#index", :type => "adherents_nonabouti")
    end
  end

  describe "Donations" do
    it "/administration?type=dons" do
      get("/administration?type=dons").should route_to("administration#index", :type => "dons")
    end

    it "/administration?type=dons_payes" do
      get("/administration?type=dons_payes").should route_to("administration#index", :type => "dons_payes")
    end

    it "/administration?type=dons_nonaboutis" do
      get("/administration?type=dons_nonaboutis").should route_to("administration#index", :type => "dons_nonaboutis")
    end
  end

  describe "Messages" do
    it "/administration?type=messages" do
      get("/administration?type=messages").should route_to("administration#index", :type => "messages")
    end
  end

  describe "History" do
    it "/administration?type=audits" do
      get("/administration?type=audits").should route_to("administration#index", :type => "audits")
    end
  end
end