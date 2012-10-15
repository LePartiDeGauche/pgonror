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

feature "Authentification" do
  context "En tant que visiteur" do
    
    scenario "j'ai accès à un formulaire accessible depuis l'accueil" do
      visit articles_path
      
      current_path.should == new_user_session_path
      page.should have_content("Adresse électronique")
      page.should have_content("Mot de passe")
    end
  end
end