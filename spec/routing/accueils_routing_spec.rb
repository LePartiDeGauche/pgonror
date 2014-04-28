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
describe "Menu home pages" do
  describe "Accueil" do
    it "/" do
      get("/").should route_to("accueil#index")
    end

    it "/search" do
      get("/search").should route_to("accueil#search")
    end
  end

  describe "Actualités" do
    it "/actualites" do
      get("/actualites").should route_to("actualites#index")
    end

    it "/actualites/editos" do
      get("/actualites/editos").should route_to("actualites#editos")
      get("/actualites/edito/X").should route_to("actualites#edito", :uri => "X")
    end

    it "/actualites/actualites" do
      get("/actualites/actualites").should route_to("actualites#actualites")
      get("/actualites/actualite/X").should route_to("actualites#actualite", :uri => "X")
    end

    it "/actualites/communiques" do
      get("/actualites/communiques").should route_to("actualites#communiques")
      get("/actualites/communique/X").should route_to("actualites#communique", :uri => "X")
    end

    it "/actualites/tout_international" do
      get("/actualites/tout_international").should route_to("actualites#tout_international")
      get("/actualites/international/X").should route_to("actualites#international", :uri => "X")
    end

    it "/actualites/dossiers" do
      get("/actualites/dossiers").should route_to("actualites#dossiers")
      get("/actualites/dossier/X").should route_to("actualites#dossier", :uri => "X")
    end
  end

  describe "Arguments" do
    it "/arguments" do
      get("/arguments").should route_to("arguments#index")
    end

    it "/arguments/arguments" do
      get("/arguments/arguments").should route_to("arguments#arguments")
      get("/arguments/argument/X").should route_to("arguments#argument", :uri => "X")
    end

    it "/arguments/leprogramme" do
      get("/arguments/leprogramme").should route_to("arguments#leprogramme")
      get("/arguments/programme/X").should route_to("arguments#programme", :uri => "X")
    end

    it "/arguments/legislatives" do
      get("/arguments/legislatives").should route_to("arguments#legislatives")
      get("/arguments/legislative/X").should route_to("arguments#legislative", :uri => "X")
    end
  end

  describe "Militer" do
    it "/militer" do
      get("/militer").should route_to("militer#index")
    end

    it "/militer/agenda" do
      get("/militer/agenda").should route_to("militer#agenda")
      get("/militer/evenement/X").should route_to("militer#evenement", :uri => "X")
    end

    it "/militer/tracts" do
      get("/militer/tracts").should route_to("militer#tracts")
      get("/militer/tract/X").should route_to("militer#tract", :uri => "X")
    end

    it "/militer/affiches" do
      get("/militer/affiches").should route_to("militer#affiches")
      get("/militer/affiche/X").should route_to("militer#affiche", :uri => "X")
    end

    it "/militer/kits" do
      get("/militer/kits").should route_to("militer#kits")
      get("/militer/kit/X").should route_to("militer#kit", :uri => "X")
    end

    it "/militer" do
      get("/militer/rss").should route_to("militer#rss", :format => :xml)
    end
  end

  describe "Educ Pop" do
    it "/educpop" do
      get("/educpop").should route_to("educpop#index")
    end

    it "/educpop/dates" do
      get("/educpop/dates").should route_to("educpop#dates")
      get("/educpop/date/X").should route_to("educpop#date", :uri => "X")
    end

    it "/educpop/revues" do
      get("/educpop/revues").should route_to("educpop#revues")
      get("/educpop/revue/X").should route_to("educpop#revue", :uri => "X")
    end

    it "/educpop/librairie" do
      get("/educpop/librairie").should route_to("educpop#librairie")
      get("/educpop/livre/X").should route_to("educpop#livre", :uri => "X")
    end

    it "/educpop/lectures" do
      get("/educpop/lectures").should route_to("educpop#lectures")
      get("/educpop/lecture/X").should route_to("educpop#lecture", :uri => "X")
    end
  end

  describe "Qui sommes-nous ?" do
    it "/quisommesnous" do
      get("/quisommesnous").should route_to("quisommesnous#index")
    end

    it "/quisommesnous/identite" do
      get("/quisommesnous/identite/X").should route_to("quisommesnous#identite", :uri => "X")
    end

    it "/quisommesnous/instance" do
      get("/quisommesnous/instance/X").should route_to("quisommesnous#instance", :uri => "X")
    end

    it "/quisommesnous/commission" do
      get("/quisommesnous/commission/X").should route_to("quisommesnous#commission", :uri => "X")
    end
  end

  describe "Vu d'ailleurs" do
    it "/vudailleurs" do
      get("/vudailleurs").should route_to("vudailleurs#index")
    end

    it "/vudailleurs/articlesweb" do
      get("/vudailleurs/articlesweb").should route_to("vudailleurs#articlesweb")
      get("/vudailleurs/articleweb/X").should route_to("vudailleurs#articleweb", :uri => "X")
    end

    it "/vudailleurs/articlesblog" do
      get("/vudailleurs/articlesblog").should route_to("vudailleurs#articlesblog")
      get("/vudailleurs/articleblog/X").should route_to("vudailleurs#articleblog", :uri => "X")
    end

    it "/vudailleurs/blogs" do
      get("/vudailleurs/blogs").should route_to("vudailleurs#blogs")
      get("/vudailleurs/blog/X").should route_to("vudailleurs#blog", :uri => "X")
    end

    it "/vudailleurs/envoyer_message" do
      post("/vudailleurs/envoyer_message").should route_to("vudailleurs#envoyer_message")
    end
  end
end

describe "Non-menu home pages" do
  it "/photos" do
    get("/photos").should route_to("photos#index")
    get("/photos/diaporama/X").should route_to("photos#diaporama", :uri => "X")
  end

  describe "Podcast" do
    it "/podcast" do
      get("/podcast").should route_to("podcast#index")
      get("/podcast/X").should route_to("podcast#son", :uri => "X")
    end

    it "/podcast/rss" do
      get("/podcast/rss").should route_to("podcast#rss", :format => :xml)
    end
  end

  describe "Vie de Gauche" do
    it "/viedegauche" do
      get("/viedegauche").should route_to("viedegauche#index")
    end

    it "/viedegauche/article" do
      get("/viedegauche/article/X").should route_to("viedegauche#article", :uri => "X")
    end

    it "/viedegauche/journauxvdg" do
      get("/viedegauche/journauxvdg").should route_to("viedegauche#journauxvdg")
      get("/viedegauche/journalvdg/X").should route_to("viedegauche#journalvdg", :uri => "X")
    end
  end

  describe "Télé de Gauche" do
    it "/lateledegauche" do
      get("/lateledegauche").should route_to("videos#lateledegauche")
      get("/lateledegauche/rss").should route_to("videos#rss", :format => :xml)
    end

    it "/lateledegauche/conferences" do
      get("/lateledegauche/conferences").should route_to("videos#conferences")
      get("/lateledegauche/conference/X").should route_to("videos#conference", :uri => "X")
    end

    it "/lateledegauche/videospresdechezvous" do
      get("/lateledegauche/videospresdechezvous").should route_to("videos#videospresdechezvous")
      get("/lateledegauche/presdechezvous/X").should route_to("videos#presdechezvous", :uri => "X")
    end

    it "/lateledegauche/medias" do
      get("/lateledegauche/medias").should route_to("videos#medias")
      get("/lateledegauche/media/X").should route_to("videos#media", :uri => "X")
    end

    it "/lateledegauche/videosagitprop" do
      get("/lateledegauche/videosagitprop").should route_to("videos#videosagitprop")
      get("/lateledegauche/agitprop/X").should route_to("videos#agitprop", :uri => "X")
    end

    it "/lateledegauche/touteducpop" do
      get("/lateledegauche/touteducpop").should route_to("videos#touteducpop")
      get("/lateledegauche/educpop/X").should route_to("videos#educpop", :uri => "X")
    end

    it "/lateledegauche/videosencampagne" do
      get("/lateledegauche/videosencampagne").should route_to("videos#videosencampagne")
      get("/lateledegauche/encampagne/X").should route_to("videos#encampagne", :uri => "X")
    end

    it "/lateledegauche/toutweb" do
      get("/lateledegauche/toutweb").should route_to("videos#toutweb")
      get("/lateledegauche/web/X").should route_to("videos#web", :uri => "X")
    end
  end

  it "/videos" do
    get("/videos").should route_to("videos#index")
    get("/videos/video/X").should route_to("videos#video", :uri => "X")
  end
end

describe "Miscellaneous" do
  it "/legal" do
    get("/legal").should route_to("accueil#legal")
  end

  it "/agauche" do
    get("/agauche").should route_to("accueil#agauche")
  end

  it "/gavroche" do
    get("/gavroche").should route_to("accueil#gavroche")
  end

  it "/rss" do
    get("/rss").should route_to("accueil#rss", :format => :xml)
  end

  it "/accueil_rss" do
    get("/accueil_rss").should route_to("accueil#accueil_rss")
  end

  it "/sitemap" do
    get("/sitemap").should route_to("accueil#sitemap", :format => :xml)
  end

  it "/export_txt" do
    get("/export_txt").should route_to("accueil#export_txt")
  end
end

describe "Input pages" do
  describe "Contact" do
    it "/contact" do
      get("/contact").should route_to("contact#index")
    end

    it "/comites" do
      get("/comites/X").should route_to("contact#departement", :uri => "X")
    end

    it "/envoyer_message" do
      post("/envoyer_message").should route_to("contact#envoyer_message")
    end
  end

  describe "Adhésions" do
    it "/adhesion" do
      get("/adhesion").should route_to("memberships#adhesion")
    end

    it "/valider_adhesion" do
      post("/valider_adhesion").should route_to("memberships#valider_adhesion")
    end

    it "/retour_paiement_adhesion" do
      get("/retour_paiement_adhesion").should route_to("memberships#retour_paiement_adhesion")
    end

    it "/adhesion_enregistree" do
      get("/adhesion_enregistree").should route_to("memberships#adhesion_enregistree")
    end

    it "/adhesion_rejetee" do
      get("/adhesion_rejetee").should route_to("memberships#adhesion_rejetee")
    end
  end

  describe "Dons" do
    it "/don" do
      get("/don").should route_to("donations#don")
    end

    it "/valider_don" do
      post("/valider_don").should route_to("donations#valider_don")
    end

    it "/retour_paiement_don" do
      get("/retour_paiement_don").should route_to("donations#retour_paiement_don")
    end

    it "/don_enregistre" do
      get("/don_enregistre").should route_to("donations#don_enregistre")
    end

    it "/don_rejete" do
      get("/don_rejete").should route_to("donations#don_rejete")
    end
  end

  describe "Paiements" do
    it "/paiement_annule" do
      get("/paiement_annule").should route_to("payment#paiement_annule")
    end
  end

  describe "Adhérents" do
    it "/adherent" do
      get("/adherent").should route_to("adherent#index")
    end

    it "/adherent/article" do
      get("/adherent/article/X").should route_to("adherent#article", :uri => "X")
    end

    it "/adherent/search" do
      get("/adherent/search").should route_to("adherent#search")
    end
  end

  it "/default" do
    get("/1").should route_to("accueil#default", :id => "1")
  end
end