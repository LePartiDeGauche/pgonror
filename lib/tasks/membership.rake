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
namespace :membership do
  task :init => :environment do
  end

  desc 'Archive and delete all memberships'
  task :archive_all => :init do
    memberships = Membership.where('updated_at < ?', Time.now - 3.month).order('created_at')
    if not memberships.empty? 
      file = File.new("tmp/archives-adhesions-#{Date.current.strftime("%Y%m%d")}.csv", "w:iso-8859-15")
      file.puts Membership::header_to_csv
      for membership in memberships
        puts "-- Archive membership #{membership}"
        file.puts membership.to_csv.encode('iso-8859-15', undef: :replace)
        membership.destroy
      end
      file.close
    else
      puts "-- No data."
    end
  end

  desc 'Export memberships created and paid within a day'
  task :export_paid => :init do
    memberships = Membership.find_paid.where(
                          'updated_at between ? and ?',
                          Time.now - 26.hour,
                          Time.now).order('created_at')
    if not memberships.empty? 
      file = File.new("tmp/adhesions_payees-#{Date.current.strftime("%Y%m%d")}.csv", "w:iso-8859-15")
      file.puts Membership::header_to_csv
      for membership in memberships
        puts "-- Export paid membership #{membership}"
        file.puts membership.to_csv.encode('iso-8859-15', undef: :replace)
      end
      file.close
    else
      puts "-- No data."
    end
  end

  desc 'Export memberships created but unpaid within a day'
  task :export_unpaid => :init do
    memberships = Membership.find_unpaid.where(
                          'updated_at between ? and ?',
                          Time.now - 26.hour,
                          Time.now).order('created_at')
    if not memberships.empty? 
      file = File.new("tmp/adhesions_suspens-#{Date.current.strftime("%Y%m%d")}.csv", "w:iso-8859-15")
      file.puts Membership::header_to_csv
      for membership in memberships
        puts "-- Export unpaid membership #{membership}"
        file.puts membership.to_csv.encode('iso-8859-15', undef: :replace)
      end
      file.close
    else
      puts "-- No data."
    end
  end
end