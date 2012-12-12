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

# Manages cache expiration for articles.
class ArticleSweeper < ActionController::Caching::Sweeper
  # This sweeper keeps an eye on the Article model.
  observe Article

  # If our sweeper detects that an Article was created call this.
  def after_create(article)
    expire_cache_for(article)
  end

  # If our sweeper detects that an Article was updated call this.
  def after_update(article)
    expire_cache_for(article)
  end

  # If our sweeper detects that an Article was deleted call this.
  def after_destroy(article)
    expire_cache_for(article)
  end

private

  # Expires the appropriate caches for a given article, 
  # depending on its category and status.  
  def expire_cache_for(article)
    if article.published? or 
       article.destroyed? or 
       (article.status_changed? or 
       article.zoom_changed? or
       article.published_at_changed? or 
       article.expired_at_changed? or
       article.category_changed?) and (article.published? or article.was_published?)
      expire_action :controller => 'accueil', :action => 'index'
      expire_action :controller => 'accueil', :action => 'rss'
      expire_action :controller => 'accueil', :action => 'sitemap'
      
      category = article.category
      category_was = article.category_was
            
      # Actualités
      if ['edito', 'com', 'actu', 'inter', 'dossier'].include?(category) or
         ['edito', 'com', 'actu', 'inter', 'dossier'].include?(category_was)
        expire_action(:controller => 'actualites', :action => 'index')
        expire_action(:controller => 'actualites', :action => 'editos')
        expire_action(:controller => 'actualites', :action => 'actualites')
        expire_action(:controller => 'actualites', :action => 'communiques')
        expire_action(:controller => 'actualites', :action => 'tout_international')
        expire_action(:controller => 'actualites', :action => 'dossiers')
        expire_action(:controller => 'viedegauche', :action => 'index')
        expire_action(:controller => 'viedegauche', :action => 'journauxvdg')
        expire_action(:controller => 'videos', :action => 'index')
      end
      
      # Arguments
      if ['programme', 'argument', 'legislative'].include?(category) or
         ['programme', 'argument', 'legislative'].include?(category_was)
        expire_action(:controller => 'arguments', :action => 'index')
        expire_action(:controller => 'arguments', :action => 'leprogramme')
        expire_action(:controller => 'arguments', :action => 'arguments')
        expire_action(:controller => 'arguments', :action => 'legislatives')
      end
      
      # Militer
      if ['campagne', 'tract', 'kit', 'affiche', 'evenement'].include?(category) or 
         ['campagne', 'tract', 'kit', 'affiche', 'evenement'].include?(category_was) or
         article.agenda or 
         article.agenda_was
        expire_action(:controller => 'militer', :action => 'index')
        expire_action(:controller => 'militer', :action => 'tracts')
        expire_action(:controller => 'militer', :action => 'kits')
        expire_action(:controller => 'militer', :action => 'affiches')
        expire_action(:controller => 'militer', :action => 'agenda')
      end
      
      # Educ Pop
      if ['date', 'livre', 'lecture', 'revue'].include?(category) or
         ['date', 'livre', 'lecture', 'revue'].include?(category_was)
        expire_action(:controller => 'educpop', :action => 'index') 
        expire_action(:controller => 'educpop', :action => 'dates') 
        expire_action(:controller => 'educpop', :action => 'librairie') 
        expire_action(:controller => 'educpop', :action => 'lectures') 
        expire_action(:controller => 'educpop', :action => 'revues') 
      end
      
      # Qui sommes-nous
      if ['identite', 'instance', 'commission', 'question'].include?(category)
         ['identite', 'instance', 'commission', 'question'].include?(category_was)
        expire_action(:controller => 'quisommesnous', :action => 'index')
      end
      
      # Vus d'ailleurs
      if ['web', 'directblog', 'blog'].include?(category) or
         ['web', 'directblog', 'blog'].include?(category_was)
        expire_action(:controller => 'vudailleurs', :action => 'index')
        expire_action(:controller => 'articlesweb', :action => 'index')
        expire_action(:controller => 'articlesblog', :action => 'index')
      end
      
      # Contact
      if ['contact', 'departement'].include?(category) or
         ['contact', 'departement'].include?(category_was)
        expire_action(:controller => 'contact', :action => 'index')
      end
      
      # Vie de Gauche
      if ['vdg', 'articlevdg'].include?(category)
         ['vdg', 'articlevdg'].include?(category_was)
        expire_action(:controller => 'viedegauche', :action => 'index')
        expire_action(:controller => 'viedegauche', :action => 'journauxvdg')
      end

      # Vidéos
      if category == 'video' or category_was == 'video'
        expire_action(:controller => 'videos', :action => 'index')
      elsif ['conference', 'videoevenement', 'media', 'videoagitprop', 'videoeduc', 'encampagne', 'videoweb',].include?(category) or
         ['conference', 'videoevenement', 'media', 'videoagitprop', 'videoeduc', 'encampagne', 'videoweb',].include?(category_was)
        expire_action(:controller => 'videos', :action => 'lateledegauche')
      end
      
      # Photos
      if category == 'diaporama' or category_was == 'diaporama'
        expire_action(:controller => 'photos', :action => 'index')
      end   

      # Sons
      if category == 'son' or category_was == 'son'
        expire_action(:controller => 'podcast', :action => 'index')
      end
    end
  end
end