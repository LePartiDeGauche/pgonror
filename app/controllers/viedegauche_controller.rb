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
class ViedegaucheController < ApplicationController
  before_filter :find_article, :only => [:article, :journalvdg]
  before_filter :load_side_articles, :only => [:index, :article, 
                                               :journalvdg, :journauxvdg]

  caches_action :index, :layout => false, :if => Proc.new { @page == 1 and not user_signed_in? }
  caches_action :journauxvdg, :layout => false, :if => Proc.new { @page == 1 and not user_signed_in? }

  def index
    @pages = Article.count_pages_published 'articlevdg'
    @articles = Article.find_published 'articlevdg', @page
  end

  def article
  end
  
  def journalvdg
  end
  
  def journauxvdg
    @pages = Article.count_pages_published 'vdg'
    @articles = Article.find_published 'vdg', @page
  end
  
private

  def load_side_articles
    @journauxvdg = Article.find_published 'vdg', 1, 1
    @articlesvdg = Article.find_published 'articlevdg', 1, 1
    @editos = Article.find_published 'edito', 1, 1
    @communiques = Article.find_published 'com', 1, 1
    @actus = Article.find_published 'actu', 1, 1
    @tout_international = Article.find_published 'inter', 1, 1
  end
end