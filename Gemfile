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

gem 'rails', '3.2.6'
gem 'sqlite3', '1.3.5', :require => 'sqlite3'
gem 'jquery-rails', '>=2.0.0'
gem 'execjs'
gem "paperclip", "~> 2.4"
gem 'truncate_html'
gem 'devise'
gem "omniauth-facebook"
gem 'omniauth-openid'
gem 'active_cmis','0.2.6', :require => 'active_cmis'
gem 'kaminari'
gem 'htmlentities'
gem 'coderay'

platforms :ruby do
  gem 'libv8' # necessary to be installed on Ubuntu
  gem 'therubyracer'
end

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails',   '~> 3.2.3'
  gem 'coffee-rails', '~> 3.2.1'
  gem 'uglifier', '>= 1.0.3'
  gem 'compass-rails'
end

group :test do
  # Pretty printed test output
  gem 'turn', :require => false
  gem 'ruby-prof'
  gem 'database_cleaner' # used to cleanup database during tests: https://github.com/bmabey/database_cleaner
  gem 'launchy'
  gem 'pry'
end

group :development do
  gem 'capistrano-ext' # To deploy with capistrano on various environments
  gem 'capistrano_colors'
end

# Specific gems used for development, to not install them use:
# > bundle install --without specifics
group :specifics do
  gem 'mailcatcher' # used to catch emails in webbrowser: http://mailcatcher.me/
  gem "system_timer", "~> 1.2.4"
end

group :development, :test do
  gem 'rspec-rails', "~> 2.8" #It needs to be in the :development group to expose generators and rake tasks without having to type RAILS_ENV=test
  gem 'capybara'
  gem 'factory_girl_rails'
  gem 'valid_attribute'
end