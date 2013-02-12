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
namespace :donation do
  task :init => :environment do
  end

  desc 'Archive and deletes all donations'
  task :archive_all => :init do
    donations = Donation.where('updated_at < ?', Time.now - 3.month).order('created_at')
    if not donations.empty? 
      file = File.new("tmp/archives-dons-#{Date.current.strftime("%Y%m%d")}.csv", "w:iso-8859-15")
      file.puts Donation::header_to_csv
      for donation in donations
        puts "-- Archive donation #{donation}"
        file.puts donation.to_csv.encode('iso-8859-15', undef: :replace)
        donation.destroy
      end
      file.close
    else
      puts "-- No data."
    end
  end

  desc 'Export donations created and paid within a day'
  task :export_paid => :init do
    donations = Donation.find_paid.where(
                          'updated_at between ? and ?',
                          Time.now - 26.hour,
                          Time.now).order('created_at')
    if not donations.empty? 
      file = File.new("tmp/dons_payes-#{Date.current.strftime("%Y%m%d")}.csv", "w:iso-8859-15")
      file.puts Donation::header_to_csv
      for donation in donations
        puts "-- Export paid donation #{donation}"
        file.puts donation.to_csv.encode('iso-8859-15', undef: :replace)
      end
      file.close
    else
      puts "-- No data."
    end
  end

  desc 'Export donations created but unpaid within a day'
  task :export_unpaid => :init do
    donations = Donation.find_unpaid.where(
                          'updated_at between ? and ?',
                          Time.now - 26.hour,
                          Time.now).order('created_at')
    if not donations.empty? 
      file = File.new("tmp/dons_suspens-#{Date.current.strftime("%Y%m%d")}.csv", "w:iso-8859-15")
      file.puts Donation::header_to_csv
      for donation in donations
        puts "-- Export unpaid donation #{donation}"
        file.puts donation.to_csv.encode('iso-8859-15', undef: :replace)
      end
      file.close
    else
      puts "-- No data."
    end
  end
end