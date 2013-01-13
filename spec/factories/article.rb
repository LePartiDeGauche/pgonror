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
  factory :article do
    category "inter"
    sequence(:title) { |n| "Article #{n}" }
    content { "<p>Contenu de l'article de catégorie '#{category}'</p>" * 15 }
    created_by "spec@lepartidegauche.fr"
    updated_by "spec@lepartidegauche.fr"
    published_at Date.today
    expired_at Date.today + 99.years

    trait :image do
      category "image"
    end

    trait :document do
      category "document"
    end

    trait :son do
      category "son"
    end

    trait :directory do
      category "directory"
    end

    trait :source do
      category "blog"
    end

    trait :event do
      category "evenement"
      start_datetime Time.now + 1.day
      end_datetime Time.now + 1.day + 1.hour
      address "Paris"
      no_endtime false
      all_day false
    end

    trait :video do
      category "conference"
    end

    trait :departement do
      category "departement"
    end

    trait :email do 
      category "commission_fonc"
      sequence(:email) { |n| "contact-#{n}@lepartidegauche.fr" }
    end

    trait :include_image do
      content "<p><img src=\"../../system/images/large/test.jpg?123\" style=\"float;\" size=\"80\"></p>"
    end

    trait :include_image_link do
      content "<p><a href=\"../../system/images/large/test.jpg?123\"></p>"
    end

    trait :include_document do
      content "<p><a href=\"../../system/documents/test.pdf?123\"></p>"
    end
    
    factory :article_image, :traits => [:image]
    factory :article_document, :traits => [:document]
    factory :article_son, :traits => [:son]
    factory :article_directory, :traits => [:directory]
    factory :article_source, :traits => [:source]
    factory :article_event, :traits => [:event]
    factory :article_video, :traits => [:video]
    factory :article_departement, :traits => [:departement]
    factory :article_email, :traits => [:email]
    factory :article_include_image, :traits => [:include_image]
    factory :article_include_image_link, :traits => [:include_image_link]
    factory :article_include_document, :traits => [:include_document]
  end
end