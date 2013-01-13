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
require 'spec_helper'
describe AdministrationController do
  render_views

  context "visitors" do
    it "index (no access)" do
      get :index
      response.should_not be_success
    end
  end

  context "non-administrator user" do
    login_user(:user)
    it "index (no access)" do
      get :index
      response.should_not be_success
    end
  end

  context "administrator user" do
    login_user(:administrator)
    it "index" do
      get :index
      response.should be_success
      10.times {
        FactoryGirl.create(:donation)
        FactoryGirl.create(:subscription)
        FactoryGirl.create(:membership)
        FactoryGirl.create(:request)
      }
      get :index, :type => 'donations', :search => 'prénom'
      response.should be_success
      get :index, :type => 'dons_payes', :search => 'prénom'
      response.should be_success
      get :index, :type => 'dons_nonaboutis', :search => 'prénom'
      response.should be_success
      get :index, :type => 'ml_subscribers'
      response.should be_success
      get :index, :type => 'adherents', :search => 'prénom'
      response.should be_success
      get :index, :type => 'adherents_paye', :search => 'prénom'
      response.should be_success
      get :index, :type => 'adherents_nonabouti', :search => 'prénom'
      response.should be_success
      get :index, :type => 'messages', :search => 'prénom'
      response.should be_success
      get :index, :type => 'audits', :search => 'prénom'
      response.should be_success
    end
  end
end