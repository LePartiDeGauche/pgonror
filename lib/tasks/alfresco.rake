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
namespace :alfresco do
  task :init => :environment do
    require File.expand_path(File.dirname(__FILE__) + '/../article_upload_phototheque')
  end

  desc 'Selects images from Alfresco repository'
  task :select => :init do
    ArticleUploadPhototheque.select(ArticleUploadPhototheque.init)
  end

  desc 'Uploads images from Alfresco repository'
  task :upload => :init do
    ArticleUploadPhototheque.upload(ArticleUploadPhototheque.init)
  end

  desc 'Destroys all the articles that were uploaded from Alfresco'
  task :delete_all => :init do
    ArticleUploadPhototheque.delete_all(['category in (?, ?) and external_id is not null', 'image', 'diaporama'])
  end
end