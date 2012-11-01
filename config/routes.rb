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
PartiDeGauche::Application.routes.draw do
  root :to => 'accueil#index'

  devise_for :users

  match '/search' => 'accueil#search', :as => 'global_search'
  match '/legal' => 'legal#index', :as => 'legal'
  match '/adhesion' => 'memberships#adhesion', :as => 'adhesion'
  match '/valider_adhesion' => 'memberships#valider_adhesion'
  match '/retour_paiement_adhesion' => 'memberships#retour_paiement_adhesion'
  match '/adhesion_enregistree' => 'memberships#adhesion_enregistree'
  match '/adhesion_rejetee' => 'memberships#adhesion_rejetee'
  match '/don' => 'donations#don', :as => 'don'
  match '/valider_don' => 'donations#valider_don'
  match '/retour_paiement_don' => 'donations#retour_paiement_don'
  match '/don_enregistre' => 'donations#don_enregistre'
  match '/don_rejete' => 'donations#don_rejete'
  match '/paiement_annule' => 'payment#paiement_annule'
  match '/agauche' => 'accueil#agauche'
  match '/gavroche' => 'accueil#gavroche'
  match '/accueil' => 'accueil#index'
  match '/actualites' => 'actualites#index'
  match '/actualites/editos' => 'actualites#editos'
  match '/actualites/edito/*uri(.format)' => 'actualites#edito'
  match '/actualites/actualites' => 'actualites#actualites'
  match '/actualites/actualite/*uri(.format)' => 'actualites#actualite'
  match '/en-france/119-arguments/*uri(.format)' => 'actualites#actualite'
  match '/actualites/communiques' => 'actualites#communiques'
  match '/actualites/communique/*uri(.format)' => 'actualites#communique'
  match '/actualites/tout_international' => 'actualites#tout_international'
  match '/actualites/international/*uri(.format)' => 'actualites#international'
  match '/actualites/dossiers' => 'actualites#dossiers'
  match '/actualites/dossier/*uri(.format)' => 'actualites#dossier'
  match '/legal/archive/*uri(.format)' => 'legal#archive'
  match '/legal/source/*uri(.format)' => 'legal#source'
  match '/editos/arguments/*uri(.format)' => 'arguments#argument'
  match '/editos/arguments' => 'arguments#arguments'
  match '/editos/actualites-internationales/*uri(.format)' => 'actualites#international'
  match '/editos/actualites-internationales' => 'actualites#tout_international'
  match '/editos/internationale-autre-gauche/*uri(.format)' => 'actualites#international'
  match '/editos/internationale-autre-gauche' => 'actualites#tout_international'
  match '/editos/actualites/*uri' => 'actualites#edito'
  match '/editos/actualites' => 'actualites#actualites'
  match '/editos/*uri' => 'actualites#edito'
  match '/editos' => 'actualites#editos'
  match '/article/*uri' => 'actualites#actualite'
  match '/international/' => 'actualites#tout_international'
  match '/adherent' => 'adherent#index', :as => 'adherents'
  match '/adherent/article/*uri(.format)' => 'adherent#article'
  match '/adherent/search' => 'adherent#search', :as => 'adherent_search'
  match '/arguments' => 'arguments#index'
  match '/arguments/leprogramme' => 'arguments#leprogramme'
  match '/arguments/programme/*uri(.format)' => 'arguments#programme'
  match '/arguments/arguments' => 'arguments#arguments'
  match '/arguments/argument/*uri(.format)' => 'arguments#argument'
  match '/arguments/legislatives' => 'arguments#legislatives'
  match '/arguments/legislative/*uri(.format)' => 'arguments#legislative'
  match '/contact' => 'contact#index'
  match '/comites/*uri(.format)' => 'contact#departement'
  match '/comites' => 'contact#index'
  match '/contact/departement/*uri(.format)' => 'contact#departement'
  match '/contacts-locaux-2/*uri(.format)' => 'contact#departement'
  match '/contact/contacts-locaux-2/*uri(.format)' => 'contact#departement'
  match '/contact/contacts-locaux-2' => 'contact#index'
  match '/envoyer_message' => 'contact#envoyer_message'
  match '/educpop' => 'educpop#index'
  match '/educpop/dates' => 'educpop#dates'
  match '/educpop/date/*uri(.format)' => 'educpop#date'
  match '/educpop/vendredis' => 'educpop#vendredis'
  match '/educpop/vendredi/*uri(.format)' => 'educpop#vendredi'
  match '/educpop/librairie' => 'educpop#librairie'
  match '/educpop/livre/*uri(.format)' => 'educpop#livre'
  match '/educpop/lectures' => 'educpop#lectures'
  match '/educpop/lecture/*uri(.format)' => 'educpop#lecture'
  match '/educpop/revues' => 'educpop#revues'
  match '/educpop/revue/*uri(.format)' => 'educpop#revue'
  match '/educpop' => 'educpop#index'
  match '/militer' => 'militer#index'
  match '/militer/agenda' => 'militer#agenda'
  match '/militer/evenement/*uri(.format)' => 'militer#evenement'
  match '/militer/tracts' => 'militer#tracts'
  match '/militer/tract/*uri(.format)' => 'militer#tract'
  match '/militer/kits' => 'militer#kits'
  match '/militer/kit/*uri(.format)' => 'militer#kit'
  match '/militer/affiches' => 'militer#affiches'
  match '/militer/affiche/*uri(.format)' => 'militer#affiche'
  match '/militer-eduquer/education-populaires' => 'militer#index'
  match '/militer-eduquer' => 'militer#index'
  match '/militer-eduquer/tracts/*uri(.format)' => 'militer#tract'
  match '/militer-eduquer/tracts' => 'militer#tracts'
  match '/militer-eduquer/affiches/*uri(.format)' => 'militer#affiche'
  match '/militer-eduquer/affiches' => 'militer#affiches'
  match '/militer/rss' => 'militer#rss', :format => :xml, :as => 'militer_rss_feed'
  match '/agenda/details/*uri(.format)' => 'militer#evenement'
  match '/agenda' => 'militer#agenda'
  match '/quisommesnous' => 'quisommesnous#index'
  match '/quisommesnous/identite/*uri(.format)' => 'quisommesnous#identite'
  match '/quisommesnous/instance/*uri(.format)' => 'quisommesnous#instance'
  match '/quisommesnous/commission/*uri(.format)' => 'quisommesnous#commission'
  match '/qui-sommes-nous/propositions' => 'quisommesnous#index'
  match '/qui-sommes-nous' => 'quisommesnous#index'
  match '/photos' => 'photos#index'
  match '/photos/diaporama/*uri(.format)' => 'photos#diaporama'
  match '/lateledegauche' => 'videos#lateledegauche'
  match '/videos' => 'videos#index'
  match '/videos/video/*uri(.format)' => 'videos#video'
  match '/viedegauche' => 'viedegauche#index'
  match '/viedegauche/article/*uri(.format)' => 'viedegauche#article'
  match '/viedegauche/journauxvdg' => 'viedegauche#journauxvdg'
  match '/viedegauche/journalvdg/*uri(.format)' => 'viedegauche#journalvdg'
  match '/vie-du-pg/vie-de-gauche/' => 'viedegauche#index'
  match '/vie-du-pg' => 'viedegauche#index'
  match '/chroniques' => 'viedegauche#index'
  match '/vudailleurs' => 'vudailleurs#index'
  match '/vudailleurs/articlesweb' => 'vudailleurs#articlesweb'
  match '/vudailleurs/articleweb/*uri(.format)' => 'vudailleurs#articleweb'
  match '/editos/vues-dailleurs/*uri(.format)' => 'vudailleurs#articleweb'
  match '/international/vue-d-ailleurs/*uri(.format)' => 'vudailleurs#articleweb'
  match '/vudailleurs/blogs' => 'vudailleurs#blogs'
  match '/vudailleurs/blog/*uri(.format)' => 'vudailleurs#blog'
  match '/vudailleurs/articlesblog' => 'vudailleurs#articlesblog'
  match '/vudailleurs/articleblog/*uri(.format)' => 'vudailleurs#articleblog'
  match '/vudailleurs/envoyer_message' => 'vudailleurs#envoyer_message'
  match '/editos/vues-dailleurs/*uri(.format)' => 'vudailleurs#articleweb'
  match '/editos/vues-dailleurs' => 'vudailleurs#articlesweb'
  match '/en-france' => 'actualites#index'
  match '/running' => 'accueil#index'
  match '/index.php' => "accueil#rss", :format => :xml
  match '/index' => 'accueil#index'
  match '/administration' => 'administration#index', :as => "administration"
  match '/podcast' => 'podcast#index'
  match '/podcast/rss' => 'podcast#rss', :format => :xml, :as => 'podcast_feed'
  match '/podcast/*uri(.format)' => 'podcast#son'
  match '/rss' => 'accueil#rss', :format => :xml, :as => 'rss_feed'
  match '/accueil_rss' => 'accueil#accueil_rss', :as => 'accueil_rss'
  match '/export_txt' => 'accueil#export_txt'
  match '/sitemap' => 'accueil#sitemap', :format => :xml
  match '/channel' => 'accueil#channel'

  resources :articles do
    get 'search', :on => :collection
    get 'panel_search', :on => :collection
    get 'panel_search_page', :on => :collection
    get 'new_child', :on => :collection
    resources :tags
  end
  resources :tags
  resources :users do
    get 'search', :on => :collection
    resources :permissions
  end

  # Insures backward comptability with legacy system
  match "/images/stories/:filename.:format", :to => redirect("/system/images/inline/stories-%{filename}.%{format}")
  match "/images/stories/illustrations/:filename.:format", :to => redirect("/system/images/inline/illustrations-%{filename}.%{format}")
  match "/images/stories/tracts/:filename.:format", :to => redirect("/system/documents/tracts-%{filename}.%{format}")
  match "/images/stories/logos/:filename.:format", :to => redirect("/system/images/inline/logos-%{filename}.%{format}")
  match "/images/stories/revue-a-gauche/:filename.:format", :to => redirect("/system/images/inline/revue-a-gauche-%{filename}.%{format}")
  match "/images/stories/swf/:filename.:format", :to => redirect("/system/swf/%{filename}.%{format}")
  match '/paybox/adhesion.html', :to => redirect("/adhesion")
  match '/editos/actualites/695', :to => redirect("/don")
  match '/editos/1735', :to => redirect("/accueil")
  match '/component/content/frontpage', :to => redirect("/accueil")

  match '*id', :to => 'accueil#default', :as => 'default'
end