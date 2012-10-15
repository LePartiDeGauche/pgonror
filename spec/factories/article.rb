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
#
# Read about factories at http://github.com/thoughtbot/factory_girl
FactoryGirl.define do
  factory :article do
    sequence :title do |n| 
      "Un article #{n}"
    end
    content "Le contenu de l'article"
    category "international"
    updated_by "David"
    published_at Date.today
    expired_at Date.today + 99.years
    
    trait :published do
      status Article::ONLINE
    end
    
    trait :with_tags do
      ignore do
        tags_count 3
      end
      after_create do |art, eval|
        FactoryGirl.create_list(:tag, eval.tags_count, :article => art)
      end
    end
    
    factory :published_article, :traits => [:published]
  end
end
