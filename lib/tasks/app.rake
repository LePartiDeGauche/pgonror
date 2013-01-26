#!/usr/bin/env rake
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
include ActionView::Helpers::DateHelper

namespace :app do
  desc 'Application status'
  task :status => :environment do
    puts "- Application status."
    last = User.last ; puts "-- Users: #{User.count} | #{last.present? ? (last.email + ',' + last.updated_at.to_s) : ''}"
    last = Permission.last ; puts "-- Permission: #{Permission.count} | #{last.present? ? (last.updated_at.to_s) : ''}"
    last = Article.last; puts "-- Articles: #{Article.count} | #{last.present? ? (last.title + ',' + last.updated_at.to_s) : ''}"
    categories = Article.find_by_status_group_by_category Article::ONLINE
    for category in categories
      puts "--- #{category[1]} : #{category[2]}"
    end
    last = Audit.last; puts "-- Audits #{Audit.count} | #{last.present? ? (last.updated_at.to_s) : ''}"
    last = Tag.last; puts "-- Tags: #{Tag.count} | #{last.present? ? (last.tag + ',' + last.updated_at.to_s) : ''}"
    last = Donation.last; puts "-- Donations: #{Donation.count} | #{last.present? ? (last.first_name + ' ' + last.last_name + ',' + last.updated_at.to_s) : ''}"
    last = Membership.last; puts "-- Membership: #{Membership.count} | #{last.present? ? (last.first_name + ' ' + last.last_name + ',' + last.updated_at.to_s) : ''}"
    last = Request.last; puts "-- Requests: #{Request.count} | #{last.present? ? (last.first_name + ' ' + last.last_name + ',' + last.updated_at.to_s) : ''}"
    last = Subscription.last; puts "-- Subscriptions: #{Subscription.count} | #{last.present? ? (last.first_name + ' ' + last.last_name + ',' + last.updated_at.to_s) : ''}"
  end

  desc 'Restarts server'
  task :restart do
    sh 'touch tmp/restart.txt'
  end

  desc 'Update status for old articles'
  task :update_old_status => :environment do
    for article in Article.where('(status is null or status = ?) and updated_at < ?', Article::NEW, Time.now - 1.month)
      puts "-- Update article #{article.title}"
      article.transaction do
        article.updated_by = "[Auto]"
        article.status = (['image', 'document'].include?(article.category) ? Article::ONLINE : Article::OFFLINE)
        article.save!
        article.create_audit! article.status, article.updated_by
      end
    end
  end
end