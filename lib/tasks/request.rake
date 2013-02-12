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
namespace :request do
  task :init => :environment do
  end

  desc 'Archive and deletes all requests'
  task :archive_all => :init do
    requests = Request.where('updated_at < ?', Time.now - 3.month).order('created_at')
    if not requests.empty? 
      file = File.new("tmp/archives-messages-#{Date.current.strftime("%Y%m%d")}.csv", "w:iso-8859-15")
      file.puts Request
      for request in requests
        puts "-- Archive request #{request}"
        file.puts request.to_csv.encode('iso-8859-15', undef: :replace)
        request.destroy
      end
      file.close
    else
      puts "-- No data."
    end
  end
end