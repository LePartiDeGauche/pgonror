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
PartiDeGauche::Application.routes.draw do
  root :to => 'accueil#index'

  devise_for :users

  get "files/download"

  match '/search' => 'accueil#search', :as => 'global_search'
  match '/legal' => 'accueil#legal', :as => 'legal'
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
  match '/agauche' => 'accueil#agauche', :as => 'agauche'
  match '/gavroche' => 'accueil#gavroche'
  match '/accueil', :to => redirect('/')
  match '/actualites' => 'actualites#index', :as => 'actualites'
  match '/actualites/editos' => 'actualites#editos'
  match '/actualites/edito/*uri(.format)' => 'actualites#edito'
  match '/actualites/edito', :to => redirect('/actualites/editos')
  match '/actualites/actualites' => 'actualites#actualites'
  match '/actualites/actualite/*uri(.format)' => 'actualites#actualite'
  match '/actualites/actualite', :to => redirect('/actualites/actualites')
  match '/actualites/communiques' => 'actualites#communiques'
  match '/actualites/communique/*uri(.format)' => 'actualites#communique'
  match '/actualites/communique', :to => redirect('/actualites/communiques')
  match '/actualites/tout_international' => 'actualites#tout_international'
  match '/actualites/international/*uri(.format)' => 'actualites#international'
  match '/actualites/international', :to => redirect('/actualites/tout_international')
  match '/actualites/dossiers' => 'actualites#dossiers'
  match '/actualites/dossier/*uri(.format)' => 'actualites#dossier'
  match '/actualites/dossier', :to => redirect('/actualites/dossiers')
  match '/adherent' => 'adherent#index', :as => 'adherents'
  match '/adherent/article/*uri(.format)' => 'adherent#article'
  match '/adherent/search' => 'adherent#search', :as => 'adherent_search'
  match '/arguments' => 'arguments#index'
  match '/arguments/leprogramme' => 'arguments#leprogramme'
  match '/arguments/programme/*uri(.format)' => 'arguments#programme'
  match '/arguments/programme', :to => redirect('/arguments/leprogramme')
  match '/arguments/arguments' => 'arguments#arguments'
  match '/arguments/argument/*uri(.format)' => 'arguments#argument'
  match '/arguments/argument', :to => redirect('/arguments/arguments')
  match '/arguments/legislatives' => 'arguments#legislatives'
  match '/arguments/legislative/*uri(.format)' => 'arguments#legislative'
  match '/contact' => 'contact#index'
  match '/comites/*uri(.format)' => 'contact#departement'
  match '/comites', :to => redirect('/contact')
  match '/envoyer_message' => 'contact#envoyer_message'
  match '/educpop' => 'educpop#index'
  match '/educpop/dates' => 'educpop#dates'
  match '/educpop/date/*uri(.format)' => 'educpop#date'
  match '/educpop/date', :to => redirect('/educpop/dates')
  match '/educpop/librairie' => 'educpop#librairie'
  match '/educpop/livre/*uri(.format)' => 'educpop#livre'
  match '/educpop/livre', :to => redirect('/educpop/librairie')
  match '/educpop/lectures' => 'educpop#lectures'
  match '/educpop/lecture/*uri(.format)' => 'educpop#lecture'
  match '/educpop/lecture', :to => redirect('/educpop/lectures')
  match '/educpop/revues' => 'educpop#revues'
  match '/educpop/revue/*uri(.format)' => 'educpop#revue'
  match '/educpop/revue', :to => redirect('/educpop/revues')
  match '/educpop' => 'educpop#index'
  match '/militer' => 'militer#index'
  match '/militer/agenda' => 'militer#agenda', :as => "agenda"
  match '/militer/evenement/*uri(.format)' => 'militer#evenement'
  match '/militer/evenement', :to => redirect('/militer/agenda')
  match '/militer/tracts' => 'militer#tracts'
  match '/militer/tract/*uri(.format)' => 'militer#tract'
  match '/militer/tract', :to => redirect('/militer/tracts')
  match '/militer/kits' => 'militer#kits'
  match '/militer/kit/*uri(.format)' => 'militer#kit'
  match '/militer/kit', :to => redirect('/militer/kits')
  match '/militer/affiches' => 'militer#affiches'
  match '/militer/affiche/*uri(.format)' => 'militer#affiche'
  match '/militer/affiche', :to => redirect('/militer/affiches')
  match '/militer/rss' => 'militer#rss', :format => :xml, :as => 'militer_rss_feed'
  match '/agenda', :to => redirect('/militer/agenda')
  match '/quisommesnous' => 'quisommesnous#index'
  match '/quisommesnous/identite/*uri(.format)' => 'quisommesnous#identite'
  match '/quisommesnous/identite', :to => redirect('/quisommesnous')
  match '/quisommesnous/instance/*uri(.format)' => 'quisommesnous#instance'
  match '/quisommesnous/instance', :to => redirect('/quisommesnous')
  match '/quisommesnous/commission/*uri(.format)' => 'quisommesnous#commission'
  match '/quisommesnous/commission', :to => redirect('/quisommesnous')
  match '/qui-sommes-nous/propositions' => 'quisommesnous#index'
  match '/qui-sommes-nous' => 'quisommesnous#index'
  match '/photos' => 'photos#index'
  match '/photos/diaporama/*uri(.format)' => 'photos#diaporama'
  match '/photos/diaporama', :to => redirect('/photos')
  match '/lateledegauche' => 'videos#lateledegauche', :as => 'lateledegauche'
  match '/lateledegauche/conferences' => 'videos#conferences'
  match '/lateledegauche/conference/*uri(.format)' => 'videos#conference'
  match '/lateledegauche/conference', :to => redirect('/lateledegauche/conferences')
  match '/lateledegauche/videospresdechezvous' => 'videos#videospresdechezvous'
  match '/lateledegauche/presdechezvous/*uri(.format)' => 'videos#presdechezvous'
  match '/lateledegauche/presdechezvous', :to => redirect('/lateledegauche/videospresdechezvous')
  match '/lateledegauche/medias' => 'videos#medias'
  match '/lateledegauche/media/*uri(.format)' => 'videos#media'
  match '/lateledegauche/media', :to => redirect('/lateledegauche/medias')
  match '/lateledegauche/videosagitprop' => 'videos#videosagitprop'
  match '/lateledegauche/agitprop/*uri(.format)' => 'videos#agitprop'
  match '/lateledegauche/agitprop', :to => redirect('/lateledegauche/videosagitprop')
  match '/lateledegauche/touteducpop' => 'videos#touteducpop'
  match '/lateledegauche/educpop/*uri(.format)' => 'videos#educpop'
  match '/lateledegauche/educpop', :to => redirect('/lateledegauche/touteducpop')
  match '/lateledegauche/videosencampagne' => 'videos#videosencampagne'
  match '/lateledegauche/encampagne/*uri(.format)' => 'videos#encampagne'
  match '/lateledegauche/encampagne', :to => redirect('/lateledegauche/videosencampagne')
  match '/lateledegauche/toutweb' => 'videos#toutweb'
  match '/lateledegauche/web/*uri(.format)' => 'videos#web'
  match '/lateledegauche/web', :to => redirect('/lateledegauche/toutweb')
  match '/lateledegauche/rss' => 'videos#rss', :format => :xml, :as => 'lateledegauche_rss_feed'
  match '/videos' => 'videos#index'
  match '/videos/video/*uri(.format)' => 'videos#video'
  match '/videos/video', :to => redirect('/lateledegauche/')
  match '/viedegauche' => 'viedegauche#index'
  match '/viedegauche/article/*uri(.format)' => 'viedegauche#article'
  match '/viedegauche/article', :to => redirect('/viedegauche')
  match '/viedegauche/journauxvdg' => 'viedegauche#journauxvdg'
  match '/viedegauche/journalvdg/*uri(.format)' => 'viedegauche#journalvdg'
  match '/viedegauche/journalvdg', :to => redirect('/viedegauche/journauxvdg')
  match '/vudailleurs' => 'vudailleurs#index'
  match '/vudailleurs/articlesweb' => 'vudailleurs#articlesweb'
  match '/vudailleurs/articleweb/*uri(.format)' => 'vudailleurs#articleweb'
  match '/vudailleurs/articleweb', :to => redirect('/vudailleurs/articlesweb')
  match '/vudailleurs/blogs' => 'vudailleurs#blogs'
  match '/vudailleurs/blog/*uri(.format)' => 'vudailleurs#blog'
  match '/vudailleurs/blog', :to => redirect('/vudailleurs/blogs')
  match '/vudailleurs/articlesblog' => 'vudailleurs#articlesblog'
  match '/vudailleurs/articleblog/*uri(.format)' => 'vudailleurs#articleblog'
  match '/vudailleurs/articleblog', :to => redirect('/vudailleurs/articlesblog')
  match '/vudailleurs/envoyer_message' => 'vudailleurs#envoyer_message'
  match '/administration' => 'administration#index', :as => "administration"
  match '/podcast' => 'podcast#index', :as => "podcast"
  match '/podcast/rss' => 'podcast#rss', :format => :xml, :as => 'podcast_feed'
  match '/podcast/*uri(.format)' => 'podcast#son'
  match '/rss' => 'accueil#rss', :format => :xml, :as => 'rss_feed'
  match '/accueil_rss' => 'accueil#accueil_rss', :as => 'accueil_rss'
  match '/export_txt' => 'accueil#export_txt'
  match '/sitemap' => 'accueil#sitemap', :format => :xml

  resources :articles do
    get 'search', :on => :collection
    get 'panel_search', :on => :collection
    get 'panel_search_page', :on => :collection
    get 'new_child', :on => :collection
    get 'headings', :on => :collection
    get 'signatures', :on => :collection
    get 'directories', :on => :collection
    resources :tags
  end
  resources :tags
  resources :users do
    get 'search', :on => :collection
    resources :permissions
  end

  # Insures backward comptability with legacy system
  match '/running', :to => redirect('/')
  match '/index.php', :to => redirect('/rss')
  match '/index', :to => redirect('/')
  match '/editos/arguments/*uri', :to => redirect('/arguments/argument/%{uri}')
  match '/editos/arguments', :to => redirect('/arguments/arguments')
  match '/editos/actualites-internationales/*uri', :to => redirect('/actualites/international/%{uri}')
  match '/editos/actualites-internationales', :to => redirect('/actualites/tout_international')
  match '/editos/internationale-autre-gauche/*uri', :to => redirect('/actualites/international/%{uri}')
  match '/editos/internationale-autre-gauche', :to => redirect('/actualites/tout_international')
  match '/editos/actualites/*uri', :to => redirect('/actualites/edito/%{uri}')
  match '/editos/actualites', :to => redirect('/actualites/actualites')
  match '/editos/*uri', :to => redirect('/actualites/edito/%{uri}')
  match '/editos', :to => redirect('/actualites/editos')
  match '/article/*uri', :to => redirect('/actualites/actualite/%{uri}')
  match '/international/', :to => redirect('/actualites/tout_international')
  match '/en-france/119-arguments/*uri', :to => redirect('/actualites/actualite/%{uri}')
  match '/editos/vues-dailleurs/*uri', :to => redirect('/vudailleurs/articleweb/%{uri}')
  match '/editos/vues-dailleurs', :to => redirect('/vudailleurs/articlesweb')
  match '/en-france', :to => redirect('/actualites/index')
  match '/contact/departement/*uri', :to => redirect('/comites/%{uri}')
  match '/contacts-locaux-2/*uri', :to => redirect('/comites/%{uri}')
  match '/contact/contacts-locaux-2/*uri', :to => redirect('/comites/%{uri}')
  match '/contact/contacts-locaux-2', :to => redirect('/contact')
  match '/editos/vues-dailleurs/*uri', :to => redirect('/vudailleurs/articleweb/%{uri}')
  match '/international/vue-d-ailleurs/*uri', :to => redirect('/vudailleurs/articleweb/%{uri}')
  match '/militer-eduquer/education-populaires', :to => redirect('/militer')
  match '/militer-eduquer', :to => redirect('/militer')
  match '/militer-eduquer/tracts/*uri', :to => redirect('/militer/tracts/%{uri}')
  match '/militer-eduquer/tracts', :to => redirect('/militer/tracts')
  match '/militer-eduquer/affiches/*uri', :to => redirect('/militer/affiches/%{uri}')
  match '/militer-eduquer/affiches', :to => redirect('/militer/affiches')
  match '/agenda/details/*uri', :to => redirect('/militer/evenement/%{uri}')
  match '/vie-du-pg/vie-de-gauche/', :to => redirect('/viedegauche')
  match '/vie-du-pg', :to => redirect('/viedegauche')
  match '/chroniques', :to => redirect('/viedegauche')
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
  match '/files/download/:type/:name' => 'files#download'

  match '*id', :to => 'accueil#default', :as => 'default'
end
