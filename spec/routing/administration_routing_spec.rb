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

describe "Routage de l'administration" do
  describe "Utilisateurs" do
    it "/users : utilisateurs" do
      get("/administration?type=adherents").should route_to("administration#index")
    end
  end
  describe "Adhésions" do
    it "/administration?type=adherents : adhésions" do
      get("/administration?type=adherents").should route_to("administration#index")
    end
    it "/administration?type=adherents : adhésions payées" do
      get("/administration?type=adherents_paye").should route_to("administration#index")
    end
    it "/administration?type=adherents : adhésions non abouties" do
      get("/administration?type=adherents_nonabouti").should route_to("administration#index")
    end
  end
  describe "Dons" do
    it "/administration?type=dons : dons" do
      get("/administration?type=dons").should route_to("administration#index")
    end
  end
  describe "Messages" do
    it "/administration?type=messages : messages" do
      get("/administration?type=messages").should route_to("administration#index")
    end
  end
  describe "Historique des modifs" do
    it "/administration?type=audits : audits" do
      get("/administration?type=audits").should route_to("administration#index")
    end
  end
end
