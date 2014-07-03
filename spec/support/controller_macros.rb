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
module ControllerMacros
  def login_user(level = :user, authorization_category = nil, authorization_category2 = nil)
    before(:each) do
      @request.env["devise.mapping"] = Devise.mappings[:user]
      user = FactoryGirl.create(level.to_sym)
      user.confirm!
      sign_in user
      unless authorization_category.nil?
        FactoryGirl.create(:permission, :user => user, :category => authorization_category)
      end
      unless authorization_category2.nil?
        FactoryGirl.create(:permission, :user => user, :category => authorization_category2)
      end
    end
  end
end