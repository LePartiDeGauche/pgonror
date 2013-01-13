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
  factory :membership do
    sequence(:email) { |i| "me-#{i}@nowhere.com" }
    department "Pas-de-Calais (62)"
    sequence(:first_name) { |i| "Prénom#{i}" }
    sequence(:last_name) { |i| "Nom#{i}" }
    gender "Homme"
    address "Avenue de la République"
    zip_code "75000"
    birthdate "01/12/1960"
    city "Paris"
    phone "0102030405"
    amount 50.0

    trait :paid do
      payment_error "00000"
      sequence(:payment_authorization) { |i| "{i}" }
    end

    trait :error do
      payment_error "999999"
    end

    factory :membership_paid, :traits => [:paid]
    factory :membership_error, :traits => [:error]
  end
end