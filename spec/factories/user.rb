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
FactoryGirl.define do
  factory :user do
    sequence(:email) { |i| "me-#{i}@lepartidegauche.fr" }
    password "poiuyt"
    password_confirmation "poiuyt"

    trait :as_member do
      access_level 'reserved'
    end

    trait :as_publisher do
      publisher true
    end
    
    trait :as_admin do
      administrator true
      notification_alert true
    end

    factory :member, :traits => [:as_member]
    factory :publisher, :traits => [:as_publisher]
    factory :administrator, :traits => [:as_admin]
    factory :super_user, :traits => [:as_publisher, :as_admin]
  end
end