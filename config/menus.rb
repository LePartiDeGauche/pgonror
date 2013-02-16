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

# Configures the content of the main menu.
# The first element defines the displayed label of the menu item.
# The second element defines options that apply for the meu item.
#  :home sets the menu item as the root of the application.
#  :controller sets the controller used in the website to display the menu page.
#  :action sets the action used in the website to display the menu page.
#  :description sets the description of the menu item.
#  :hide hides the menu item from the menu.
#  :hide_main_menu hides the whole menu.
#  :identity_layout sets the template the be used for rendering the identity header.
#  :identity_icon defines the icon to be used for page and RSS flow rendering.
MENU = [
  ["Accueil", {:home => true,
               :controller => :accueil,
               :action => :index,
               :description => "Le Parti de Gauche fait le lien entre l’urgence écologique, la crise sociale et républicaine de la France et du monde pour proposer une orientation de rupture avec le capitalisme et le productiviste ainsi qu’un renouveau républicain des institutions"}],
  ["Actualités", {:controller => :actualites,
                  :action => :index,
                  :description => "Éditos, actualités en France, actualités internationales, communiqués et dossiers du Parti de Gauche"}],
  ["Arguments - Programme", {:controller => :arguments,
                             :action => :index,
                             :description => "Le programme du Front de Gauche ainsi que les arguments"}],
  ["Militer", {:controller => :militer,
               :action => :index,
               :description => "Affiches, tracts et logos, kit et agenda militants du Parti de Gauche"}],
  ["Éduc Pop", {:controller => :educpop,
                :action => :index,
                :description => "Librairie militante, revue À Gauche, une date un jour et fiches de lecture du Parti de Gauche"}],
  ["Qui sommes-nous ?", {:controller => :quisommesnous,
                         :action => :index,
                         :description => "Identité, instances, pôles et commissions du Parti de Gauche"}],
  ["Vu d’ailleurs", {:controller => :vudailleurs,
                     :action => :index,
                     :description => "Articles d’actualités et articles de blogs vus sur le web"}],
  ["Contact", {:controller => :contact,
               :action => :index,
               :description => "Messages et contacts du Parti de Gauche"}],
  ["À Gauche", {:controller => :accueil,
                :action => :agauche,
                :hide => true,
                :description => "Abonnement au journal À Gauche"}],
  ["Gavroche", {:controller => :accueil,
                :action => :gavroche,
                :hide => true,
                :description => "Journal du réseau jeune du Parti de Gauche"}],
  ["Recherche", {:controller => :accueil,
                 :action => :search,
                 :hide => true,
                 :description => "Recherche en ligne d’articles du Parti de Gauche"}],
  ["Adhésion au Parti de Gauche", {:controller => :memberships,
                                   :action => :adhesion,
                                   :hide => true,
                                   :description => "Adhésion en ligne et formulaire d’adhésion au Parti de Gauche"}],
  ["Don au Parti de Gauche", {:controller => :donations,
                              :action => :don,
                              :hide => true,
                              :description => "Dons en ligne et formulaire de dons au Parti de Gauche"}],
  ["Mentions légales", {:controller => :accueil,
                        :action => :legal,
                        :hide => true,
                        :description => "Site publié par le Parti de Gauche - Écologie • Socialisme • République"}],
  ["Photos", {:controller => :photos,
              :action => :index,
              :hide => true,
              :description => "Diaporamas du Parti de Gauche"}],
  ["Vie de Gauche", {:controller => :viedegauche,
                     :action => :index,
                     :hide => true,
                     :description => "Articles sur la vie du Parti de Gauche"}],
  ["Télé de Gauche", {:controller => :videos,
                      :action => :lateledegauche,
                      :hide => true,
                      :hide_main_menu => true,
                      :identity_layout => "videos/identity",
                      :identity_icon => "logo-tele-de-gauche-large.png",
                      :description => "La Télé de Gauche, ce sont des émissions sur votre poste de télévision de gauche"}],
  ["Vidéos", {:controller => :videos,
              :action => :index,
              :hide => true,
              :description => "Vidéos du Parti de Gauche en ligne"}],
  ["Flux RSS", {:controller => :accueil,
                :action => :accueil_rss,
                :hide => true,
                :description => "Flux RSS du Parti de Gauche - Écologie • Socialisme • République"}],
  ["À la une", {:controller => :accueil,
                :action => :rss,
                :hide => true,
                :description => "Actualités du Parti de Gauche - Écologie • Socialisme • République"}],
  ["Agenda", {:controller => :militer,
              :action => :rss,
              :hide => true,
              :description => "Agenda du Parti de Gauche - Écologie • Socialisme • République"}],
  ["Télé de Gauche", {:controller => :videos,
                      :action => :rss,
                      :hide => true,
                      :identity_icon => "logo-tele-de-gauche-large.png",
                      :description => "La télé de Gauche - Écologie • Socialisme • République"}],
  ["Radio de Gauche", {:controller => :podcast,
                       :action => :index,
                       :hide => true,
                       :hide_main_menu => true,
                       :identity_layout => "podcast/identity",
                       :identity_icon => "logo-radio-de-gauche-large.png",
                       :description => "La radio du Parti de Gauche - Écologie • Socialisme • République"}],
  ["Podcat de Gauche", {:controller => :podcast,
                        :action => :rss,
                        :hide => true,
                        :identity_icon => "logo-radio-de-gauche-large.png",
                        :description => "Podcast du Parti de Gauche - Écologie • Socialisme • République"}]
]