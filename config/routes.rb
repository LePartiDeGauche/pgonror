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

  get '/search' => 'accueil#search', :as => 'global_search'
  get '/legal' => 'accueil#legal', :as => 'legal'
  get '/adhesion' => 'memberships#adhesion', :as => 'adhesion'
  post '/valider_adhesion' => 'memberships#valider_adhesion'
  get '/retour_paiement_adhesion' => 'memberships#retour_paiement_adhesion'
  get '/adhesion_enregistree' => 'memberships#adhesion_enregistree'
  get '/adhesion_rejetee' => 'memberships#adhesion_rejetee'
  get '/don' => 'donations#don', :as => 'don'
  post '/valider_don' => 'donations#valider_don'
  get '/retour_paiement_don' => 'donations#retour_paiement_don'
  get '/don_enregistre' => 'donations#don_enregistre'
  get '/don_rejete' => 'donations#don_rejete'
  get '/paiement_annule' => 'payment#paiement_annule'
  get '/agauche' => 'accueil#agauche', :as => 'agauche'
  get '/gavroche' => 'accueil#gavroche'
  get '/accueil', :to => redirect('/')
  get '/actualites' => 'actualites#index', :as => 'actualites'
  get '/actualites/editos' => 'actualites#editos'
  get '/actualites/edito/*uri(.format)' => 'actualites#edito'
  get '/actualites/edito', :to => redirect('/actualites/editos')
  get '/actualites/actualites' => 'actualites#actualites'
  get '/actualites/actualite/*uri(.format)' => 'actualites#actualite'
  get '/actualites/actualite', :to => redirect('/actualites/actualites')
  get '/actualites/communiques' => 'actualites#communiques'
  get '/actualites/communique/*uri(.format)' => 'actualites#communique'
  get '/actualites/communique', :to => redirect('/actualites/communiques')
  get '/actualites/tout_international' => 'actualites#tout_international'
  get '/actualites/international/*uri(.format)' => 'actualites#international'
  get '/actualites/international', :to => redirect('/actualites/tout_international')
  get '/actualites/dossiers' => 'actualites#dossiers'
  get '/actualites/dossier/*uri(.format)' => 'actualites#dossier'
  get '/actualites/dossier', :to => redirect('/actualites/dossiers')
  get '/adherent' => 'adherent#index', :as => 'adherents'
  get '/adherent/article/*uri(.format)' => 'adherent#article'
  get '/adherent/search' => 'adherent#search', :as => 'adherent_search'
  get '/arguments' => 'arguments#index'
  get '/arguments/leprogramme' => 'arguments#leprogramme'
  get '/arguments/programme/*uri(.format)' => 'arguments#programme'
  get '/arguments/programme', :to => redirect('/arguments/leprogramme')
  get '/arguments/arguments' => 'arguments#arguments'
  get '/arguments/argument/*uri(.format)' => 'arguments#argument'
  get '/arguments/argument', :to => redirect('/arguments/arguments')
  get '/arguments/legislatives' => 'arguments#legislatives'
  get '/arguments/legislative/*uri(.format)' => 'arguments#legislative'
  get '/contact' => 'contact#index'
  get '/comites/*uri(.format)' => 'contact#departement'
  get '/comites', :to => redirect('/contact')
  post '/envoyer_message' => 'contact#envoyer_message'
  get '/educpop' => 'educpop#index'
  get '/educpop/dates' => 'educpop#dates'
  get '/educpop/date/*uri(.format)' => 'educpop#date'
  get '/educpop/date', :to => redirect('/educpop/dates')
  get '/educpop/librairie' => 'educpop#librairie'
  get '/educpop/livre/*uri(.format)' => 'educpop#livre'
  get '/educpop/livre', :to => redirect('/educpop/librairie')
  get '/educpop/lectures' => 'educpop#lectures'
  get '/educpop/lecture/*uri(.format)' => 'educpop#lecture'
  get '/educpop/lecture', :to => redirect('/educpop/lectures')
  get '/educpop/revues' => 'educpop#revues'
  get '/educpop/revue/*uri(.format)' => 'educpop#revue'
  get '/educpop/revue', :to => redirect('/educpop/revues')
  get '/educpop' => 'educpop#index'
  get '/militer' => 'militer#index'
  get '/militer/agenda' => 'militer#agenda', :as => "agenda"
  get '/militer/evenement/*uri(.format)' => 'militer#evenement'
  get '/militer/evenement', :to => redirect('/militer/agenda')
  get '/militer/tracts' => 'militer#tracts'
  get '/militer/tract/*uri(.format)' => 'militer#tract'
  get '/militer/tract', :to => redirect('/militer/tracts')
  get '/militer/kits' => 'militer#kits'
  get '/militer/kit/*uri(.format)' => 'militer#kit'
  get '/militer/kit', :to => redirect('/militer/kits')
  get '/militer/affiches' => 'militer#affiches'
  get '/militer/affiche/*uri(.format)' => 'militer#affiche'
  get '/militer/affiche', :to => redirect('/militer/affiches')
  post '/militer/inscription' => 'militer#inscription'
  get '/militer/rss' => 'militer#rss', :defaults => { format: :xml }, :as => 'militer_rss_feed'
  get '/agenda', :to => redirect('/militer/agenda')
  get '/quisommesnous' => 'quisommesnous#index'
  get '/quisommesnous/identite/*uri(.format)' => 'quisommesnous#identite'
  get '/quisommesnous/identite', :to => redirect('/quisommesnous')
  get '/quisommesnous/instance/*uri(.format)' => 'quisommesnous#instance'
  get '/quisommesnous/instance', :to => redirect('/quisommesnous')
  get '/quisommesnous/commission/*uri(.format)' => 'quisommesnous#commission'
  get '/quisommesnous/commission', :to => redirect('/quisommesnous')
  get '/qui-sommes-nous/propositions' => 'quisommesnous#index'
  get '/qui-sommes-nous' => 'quisommesnous#index'
  get '/photos' => 'photos#index'
  get '/photos/diaporama/*uri(.format)' => 'photos#diaporama'
  get '/photos/diaporama', :to => redirect('/photos')
  get '/lateledegauche' => 'videos#lateledegauche', :as => 'lateledegauche'
  get '/lateledegauche/conferences' => 'videos#conferences'
  get '/lateledegauche/conference/*uri(.format)' => 'videos#conference'
  get '/lateledegauche/conference', :to => redirect('/lateledegauche/conferences')
  get '/lateledegauche/videospresdechezvous' => 'videos#videospresdechezvous'
  get '/lateledegauche/presdechezvous/*uri(.format)' => 'videos#presdechezvous'
  get '/lateledegauche/presdechezvous', :to => redirect('/lateledegauche/videospresdechezvous')
  get '/lateledegauche/medias' => 'videos#medias'
  get '/lateledegauche/media/*uri(.format)' => 'videos#media'
  get '/lateledegauche/media', :to => redirect('/lateledegauche/medias')
  get '/lateledegauche/videosagitprop' => 'videos#videosagitprop'
  get '/lateledegauche/agitprop/*uri(.format)' => 'videos#agitprop'
  get '/lateledegauche/agitprop', :to => redirect('/lateledegauche/videosagitprop')
  get '/lateledegauche/touteducpop' => 'videos#touteducpop'
  get '/lateledegauche/educpop/*uri(.format)' => 'videos#educpop'
  get '/lateledegauche/educpop', :to => redirect('/lateledegauche/touteducpop')
  get '/lateledegauche/videosencampagne' => 'videos#videosencampagne'
  get '/lateledegauche/encampagne/*uri(.format)' => 'videos#encampagne'
  get '/lateledegauche/encampagne', :to => redirect('/lateledegauche/videosencampagne')
  get '/lateledegauche/toutweb' => 'videos#toutweb'
  get '/lateledegauche/web/*uri(.format)' => 'videos#web'
  get '/lateledegauche/web', :to => redirect('/lateledegauche/toutweb')
  get '/lateledegauche/rss' => 'videos#rss', :defaults => { format: :xml }, :as => 'lateledegauche_rss_feed'
  get '/videos' => 'videos#index'
  get '/videos/video/*uri(.format)' => 'videos#video'
  get '/videos/video', :to => redirect('/lateledegauche/')
  get '/viedegauche' => 'viedegauche#index'
  get '/viedegauche/article/*uri(.format)' => 'viedegauche#article'
  get '/viedegauche/article', :to => redirect('/viedegauche')
  get '/viedegauche/journauxvdg' => 'viedegauche#journauxvdg'
  get '/viedegauche/journalvdg/*uri(.format)' => 'viedegauche#journalvdg'
  get '/viedegauche/journalvdg', :to => redirect('/viedegauche/journauxvdg')
  get '/vudailleurs' => 'vudailleurs#index'
  get '/vudailleurs/articlesweb' => 'vudailleurs#articlesweb'
  get '/vudailleurs/articleweb/*uri(.format)' => 'vudailleurs#articleweb'
  get '/vudailleurs/articleweb', :to => redirect('/vudailleurs/articlesweb')
  get '/vudailleurs/blogs' => 'vudailleurs#blogs'
  get '/vudailleurs/blog/*uri(.format)' => 'vudailleurs#blog'
  get '/vudailleurs/blog', :to => redirect('/vudailleurs/blogs')
  get '/vudailleurs/articlesblog' => 'vudailleurs#articlesblog'
  get '/vudailleurs/articleblog/*uri(.format)' => 'vudailleurs#articleblog'
  get '/vudailleurs/articleblog', :to => redirect('/vudailleurs/articlesblog')
  post '/vudailleurs/envoyer_message' => 'vudailleurs#envoyer_message'
  get '/administration' => 'administration#index', :as => "administration"
  get '/podcast' => 'podcast#index', :as => "podcast"
  get '/podcast/rss' => 'podcast#rss', :defaults => { format: :xml }, :as => 'podcast_feed'
  get '/podcast/*uri(.format)' => 'podcast#son'
  get '/rss' => 'accueil#rss', :defaults => { format: :xml }, :as => 'rss_feed'
  get '/accueil_rss' => 'accueil#accueil_rss', :as => 'accueil_rss'
  get '/export_txt' => 'accueil#export_txt', :as => 'export_txt'
  get '/sitemap' => 'accueil#sitemap', :defaults => { format: :xml }

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
  get '/running', :to => redirect('/')
  get '/index.php', :to => redirect('/rss')
  get '/index', :to => redirect('/')
  get '/editos/arguments/*uri', :to => redirect('/arguments/argument/%{uri}')
  get '/editos/arguments', :to => redirect('/arguments/arguments')
  get '/editos/actualites-internationales/*uri', :to => redirect('/actualites/international/%{uri}')
  get '/editos/actualites-internationales', :to => redirect('/actualites/tout_international')
  get '/editos/internationale-autre-gauche/*uri', :to => redirect('/actualites/international/%{uri}')
  get '/editos/internationale-autre-gauche', :to => redirect('/actualites/tout_international')
  get '/editos/actualites/*uri', :to => redirect('/actualites/edito/%{uri}')
  get '/editos/actualites', :to => redirect('/actualites/actualites')
  get '/editos/*uri', :to => redirect('/actualites/edito/%{uri}')
  get '/editos', :to => redirect('/actualites/editos')
  get '/article/*uri', :to => redirect('/actualites/actualite/%{uri}')
  get '/international/', :to => redirect('/actualites/tout_international')
  get '/en-france/119-arguments/*uri', :to => redirect('/actualites/actualite/%{uri}')
  get '/editos/vues-dailleurs/*uri', :to => redirect('/vudailleurs/articleweb/%{uri}')
  get '/editos/vues-dailleurs', :to => redirect('/vudailleurs/articlesweb')
  get '/en-france', :to => redirect('/actualites/index')
  get '/contact/departement/*uri', :to => redirect('/comites/%{uri}')
  get '/contacts-locaux-2/*uri', :to => redirect('/comites/%{uri}')
  get '/contact/contacts-locaux-2/*uri', :to => redirect('/comites/%{uri}')
  get '/contact/contacts-locaux-2', :to => redirect('/contact')
  get '/editos/vues-dailleurs/*uri', :to => redirect('/vudailleurs/articleweb/%{uri}')
  get '/international/vue-d-ailleurs/*uri', :to => redirect('/vudailleurs/articleweb/%{uri}')
  get '/militer-eduquer/education-populaires', :to => redirect('/militer')
  get '/militer-eduquer', :to => redirect('/militer')
  get '/militer-eduquer/tracts/*uri', :to => redirect('/militer/tracts/%{uri}')
  get '/militer-eduquer/tracts', :to => redirect('/militer/tracts')
  get '/militer-eduquer/affiches/*uri', :to => redirect('/militer/affiches/%{uri}')
  get '/militer-eduquer/affiches', :to => redirect('/militer/affiches')
  get '/agenda/details/*uri', :to => redirect('/militer/evenement/%{uri}')
  get '/vie-du-pg/vie-de-gauche/', :to => redirect('/viedegauche')
  get '/vie-du-pg', :to => redirect('/viedegauche')
  get '/chroniques', :to => redirect('/viedegauche')
  get "/images/stories/:filename.:format", :to => redirect("/system/images/inline/stories-%{filename}.%{format}")
  get "/images/stories/illustrations/:filename.:format", :to => redirect("/system/images/inline/illustrations-%{filename}.%{format}")
  get "/images/stories/tracts/:filename.:format", :to => redirect("/system/documents/tracts-%{filename}.%{format}")
  get "/images/stories/logos/:filename.:format", :to => redirect("/system/images/inline/logos-%{filename}.%{format}")
  get "/images/stories/revue-a-gauche/:filename.:format", :to => redirect("/system/images/inline/revue-a-gauche-%{filename}.%{format}")
  get "/images/stories/swf/:filename.:format", :to => redirect("/system/swf/%{filename}.%{format}")
  get '/paybox/adhesion.html', :to => redirect("/adhesion")
  get '/editos/actualites/695', :to => redirect("/don")
  get '/editos/1735', :to => redirect("/accueil")
  get '/component/content/frontpage', :to => redirect("/accueil")
  get '/files/download/:type/:folder/:name' => 'files#download'

  post '*id', :to => 'accueil#default', :as => 'default_post'
  get '*id', :to => 'accueil#default', :as => 'default'
end
