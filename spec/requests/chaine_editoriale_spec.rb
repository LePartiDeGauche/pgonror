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

feature "Chaine éditoriale" do
  
  context "En tant qu'éditeur" do
    login_user(:publisher)
    
    scenario "j'ai accès à la liste des articles" do
      visit root_path
      click_link "Chaîne éditoriale"
      
      current_path.should == articles_path
    end
    
    scenario "je peux créer un article", :js do
      visit articles_path
      within '#new-content' do
        select 'ACTUALITÉ', :from => 'category'
      end
      
      current_path.should == new_article_path
    end
    
    scenario "je peux rechercher des articles",:js do
      article = FactoryGirl.create(:article)
      visit articles_path
      within '#search-box'do
        fill_in 'search', :with => article.title
      end
      
      within '#articles-box' do
        page.should have_content(article.title)
      end
    end
  end
end