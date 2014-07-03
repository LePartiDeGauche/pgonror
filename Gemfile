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
source 'http://rubygems.org'

gem 'rails', '4.1.4'
gem 'coffee-rails', '~> 4.0.1'
gem 'sass-rails', '~> 4.0.1'
gem "compass-rails", "~> 1.1.2"
gem 'uglifier', '>= 1.3.0'
gem 'sqlite3', '~> 1.3.6', :require => 'sqlite3'
gem 'jquery-rails', "2.3.0"
gem 'execjs'
gem "paperclip"
gem 'truncate_html'
gem 'devise'
gem 'active_cmis',">= 0.3.2", :require => 'active_cmis'
gem 'htmlentities'
gem 'ruby-mp3info'
gem 'geocoder'
gem 'yaml_db'
gem 'thin'
gem 'newrelic_rpm'
gem 'capistrano-unicorn'

platforms :ruby do
  gem 'libv8'
  gem 'therubyracer', '~> 0.11.3'
end

group :server do
  gem 'unicorn'
  gem 'mysql2'
  gem 'dalli'
end

group :development do
  gem 'capistrano-ext'
  gem 'capistrano_colors'
end

group :development, :test do
  gem 'turn', :require => false
  gem 'database_cleaner', "1.0.1"
  gem 'simplecov'
  gem 'rspec-rails', "~> 2.8"
  gem 'factory_girl_rails'
  gem 'valid_attribute'
end
