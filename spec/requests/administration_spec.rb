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

feature "Administration" do
  context "En tant qu'administrateur" do
    login_user(:administrator)
    
    scenario "j'ai accès à la page d'administration" do
      visit root_path
      click_link 'Administration'
      
      current_path.should == users_path
    end
    
    scenario "je peux lister les utilisateurs", :js do
      @user = FactoryGirl.create(:user)
      visit users_path
      within '#user-search' do
        click_button 'Rechercher'
      end
      
      page.should have_content(@user.email)
    end
  end
end 