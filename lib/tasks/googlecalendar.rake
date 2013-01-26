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

namespace :googlecalendar do
  task :init => :environment do
    require File.expand_path(File.dirname(__FILE__) + '/../article_googlecalendar')
  end
  
  desc 'Imports events restarts the web server'
  task :import_all do
     Rake::Task["googlecalendar:import"].invoke
  end

  desc 'Imports google calandar events'
  task :import => :init do
    Dir.foreach("import") do |file_name|
      if file_name.match(/export_googlecalendar(\d)+.xml/)
        ArticleGooglecalendar.import "import/" + file_name
      end
    end
  end
end