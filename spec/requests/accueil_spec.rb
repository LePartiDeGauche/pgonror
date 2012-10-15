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
require 'spec_helper'

feature "Page d'accueil" do
  context "en tant que visiteur" do
    scenario "j'ai accès aux mentions légales" do
      legal = FactoryGirl.create(:published_article, :category => 'legal', :content => 'Publié par le PG')
      visit root_path
      click_link "Mentions légales"
      
      page.should have_content(legal.content)
    end
    
    context "sur la page d'un article" do
      scenario "je peux accéder à tous les articles d'un même tag", :focus do
        article = FactoryGirl.create(:published_article, :with_tags, :category => 'edito')
        pending "je ne vois pas comment afficher simplement un article... :("
        visit root_path
        click_link article.title
        click_link article.tags.first.tag
        
        current_path.should == articles_path
        page.should have_content article.title
      end
    end
  end
end