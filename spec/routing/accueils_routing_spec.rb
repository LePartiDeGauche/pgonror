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

describe "Routage des Accueils" do
  describe "Accueil" do
    it "/ => accueil#index" do
      get("/").should route_to("accueil#index")
    end
    
  end
  describe "Actualités" do
    it "/actualites => actualites#index" do
      get("/actualites").should route_to("actualites#index")
    end
    it "/actualites/editos => actualites#editos" do
      get("/actualites/editos").should route_to("actualites#editos")
    end
    it "/actualites/actualites => actualites#actualites" do
      get("/actualites/actualites").should route_to("actualites#actualites")
    end
    it "/actualites/communiques => actualites#communiques" do
      get("/actualites/communiques").should route_to("actualites#communiques")
    end
    it "/actualites/tout_international => actualites#tout_international" do
      get("/actualites/tout_international").should route_to("actualites#tout_international")
    end
    it "/actualites/dossiers => actualites#dossiers" do
      get("/actualites/dossiers").should route_to("actualites#dossiers")
    end
  end
  describe "Arguments" do
    it "/arguments => arguments#index" do
      get("/arguments").should route_to("arguments#index")
    end
    it "/arguments/arguments => arguments#arguments" do
      get("/arguments/arguments").should route_to("arguments#arguments")
    end
    it "/arguments/leprogramme => arguments#leprogramme" do
      get("/arguments/leprogramme").should route_to("arguments#leprogramme")
    end
  end
  describe "Militer" do
    it "/militer => militer#index" do
      get("/militer").should route_to("militer#index")
    end
    it "/militer/agenda => militer#agenda" do
      get("/militer/agenda").should route_to("militer#agenda")
    end
    it "/militer/tracts => militer#tracts" do
      get("/militer/tracts").should route_to("militer#tracts")
    end
    it "/militer/affiches => militer#affiches" do
      get("/militer/affiches").should route_to("militer#affiches")
    end
  end
  describe "Educ Pop" do
    it "/educpop => educpop#index" do
      get("/educpop").should route_to("educpop#index")
    end
    it "/educpop/dates => educpop#dates" do
      get("/educpop/dates").should route_to("educpop#dates")
    end
    it "/educpop/revues => educpop#revues" do
      get("/educpop/revues").should route_to("educpop#revues")
    end
    it "/educpop/librairie => educpop#librairie" do
      get("/educpop/librairie").should route_to("educpop#librairie")
    end
    it "/educpop/lectures => educpop#lectures" do
      get("/educpop/lectures").should route_to("educpop#lectures")
    end
  end
  describe "Qui sommes-nous ?" do
    it "/quisommesnous => quisommesnous#index" do
      get("/quisommesnous").should route_to("quisommesnous#index")
    end
  end
  describe "Vu d'ailleurs" do
    it "/vudailleurs => vudailleurs#index" do
      get("/vudailleurs").should route_to("vudailleurs#index")
    end
    it "/vudailleurs/articlesweb => vudailleurs#articlesweb" do
      get("/vudailleurs/articlesweb").should route_to("vudailleurs#articlesweb")
    end
    it "/vudailleurs/articlesblog => vudailleurs#articlesblog" do
      get("/vudailleurs/articlesblog").should route_to("vudailleurs#articlesblog")
    end
  end
  describe "Contact" do
    it "/contact => contact#index" do
      get("/contact").should route_to("contact#index")
    end
  end
  describe "Adhésions" do
    it "/adhesion : nouvelle adhésion" do
      get("/adhesion").should route_to("memberships#adhesion")
    end
  end
  describe "Dons" do
    it "/don : faire un don" do
      get("/don").should route_to("donations#don")
    end
  end
end
