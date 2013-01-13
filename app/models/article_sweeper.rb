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

  # Expires appropriate caches for a given article category.  
  def expire_cache_for_category(category, uri)
    if Article.category_option?(category, :controller)
      for menu in MENU
        if menu[1][:controller].present? and
           menu[1][:controller] == Article.category_option(category, :controller) and
           menu[1][:action].present?
          expire_action :controller => Article.category_option(category, :controller),
                        :action => menu[1][:action]
        end
      end
      if Article.category_option?(category, :action_all)
        expire_action :controller => Article.category_option(category, :controller),
                      :action => Article.category_option(category, :action_all)
      end
      if Article.category_option?(category, :action)
        expire_action :controller => Article.category_option(category, :controller),
                      :action => Article.category_option(category, :action),
                      :uri => uri
      end
    end
  end

  # Expires appropriate caches for a given article, 
  def expire_cache_for(article)
    if article.published? or article.was_published? or article.destroyed?
      expire_action :controller => 'accueil', :action => 'index'
      expire_action :controller => 'accueil', :action => 'rss'
      expire_action :controller => 'militer', :action => 'rss'
      expire_action :controller => 'podcast', :action => 'rss'
      expire_action :controller => 'accueil', :action => 'sitemap'
      category = article.category
      category_was = article.category_was
      expire_cache_for_category(category, article.uri)
      expire_cache_for_category(category_was, article.uri) if category != category_was
    end
  end
end