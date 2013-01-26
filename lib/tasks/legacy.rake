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

namespace :legacy do
  task :init => :environment do
    require File.expand_path(File.dirname(__FILE__) + '/../article_upload')
    require File.expand_path(File.dirname(__FILE__) + '/../user_upload')
  end
  
  desc 'Uploads everything and restarts the web server'
  task :upload_all do
     Rake::Task["legacy:upload_documents"].invoke
     Rake::Task["legacy:upload"].invoke
     Rake::Task["legacy:upload_events"].invoke
     Rake::Task["legacy:update_sources"].invoke
  end
  
  desc 'Uploads legacy articles'
  task :upload => :init do
    ArticleUpload.upload_legacy "import/export1.xml"
  end
  
  desc 'Uploads legacy events'
  task :upload_events => :init do
    ArticleUpload.upload_legacy "import/export2.xml"
  end
  
  desc 'Uploads legacy videos'
  task :upload_videos => :init do
    ArticleUpload.upload_videos "import/export3.xml"
  end
  
  desc 'Destroys videos that were uploaded from legacy system'
  task :delete_videos => :init do
    ArticleUpload.delete_all(['legacy = ? and category in (?,?,?,?,?,?,?) and created_by = ?', true,
                              'conference', 'videoevenement', 'media', 'videoagitprop', 'videoeduc', 'encampagne', 'videofdg',
                              "[Reprise de données TeleDeGauche]"])
  end

  desc 'Uploads documents as legacy articles'
  task :upload_documents => :init do
    ArticleUpload.upload_legacy_documents "stories", "Images", "import/images/stories/"
    ArticleUpload.upload_legacy_documents "illustrations", "Illustrations", "import/images/stories/illustrations/"
    ArticleUpload.upload_legacy_documents "revue-a-gauche", "Revue A gauche", "import/images/stories/revue-a-gauche/"
    ArticleUpload.upload_legacy_documents "vdg", "Vie de gauche", "import/images/stories/vdg/"
    ArticleUpload.upload_legacy_documents "video", "Vidéo", "import/images/stories/video/"
    ArticleUpload.upload_legacy_documents "textes", "Textes", "import/images/stories/textes/"
    ArticleUpload.upload_legacy_documents "tracts", "Tracts", "import/images/stories/tracts/"
    ArticleUpload.upload_legacy_documents "circulaires", "Circulaires", "import/images/stories/circulaires/"
    ArticleUpload.upload_legacy_documents "adl", "Ateliers de lecture", "import/images/stories/adl/"
    ArticleUpload.upload_legacy_documents "affiches", "Affiches", "import/images/stories/affiches/"
    ArticleUpload.upload_legacy_documents "docs-pg", "Documents PG", "import/images/stories/docs-pg/"
    ArticleUpload.upload_legacy_documents "formations", "Formations", "import/images/stories/formations/"
    ArticleUpload.upload_legacy_documents "gavroche", "Gavroche", "import/images/stories/gavroche/"
    ArticleUpload.upload_legacy_documents "logos", "Logos", "import/images/stories/logos/"
    ArticleUpload.upload_legacy_documents "bestof-militant", "Militants", "import/images/bestof-militant/", "diaporama"
    ArticleUpload.upload_legacy_documents "porta_del_sol", "Puerta del Sol", "import/images/stories/porta_del_sol/", "diaporama"
    ArticleUpload.upload_legacy_documents "4-septembre", "4 Septembre", "import/images/stories/popup/4-septembre/", "diaporama"
  end
  
  desc 'Update the source of information for some categories of articles'
  task :update_sources => :init do
    ArticleUpload.update_sources
  end

  desc 'Destroys articles (not images, documents or directories) that were uploaded from legacy system'
  task :delete_articles => :init do
    ArticleUpload.delete_all(['legacy = ? and category not in (?, ?, ?, ?)', true, 'image', 'document', 'directory', 'diaporama'])
  end

  desc 'Destroys images, documents or directories that were uploaded from legacy system'
  task :delete_documents => :init do
    ArticleUpload.delete_all(['legacy = ? and category in (?, ?, ?, ?)', true, 'image', 'document', 'directory', 'diaporama'])
  end

  desc 'Destroys events that were uploaded from legacy system'
  task :delete_events => :init do
    ArticleUpload.delete_all(['legacy = ? and category in (?)', true, 'evenement'])
  end

  desc 'Destroys all the articles that were uploaded from legacy system'
  task :delete_all => :init do
    ArticleUpload.delete_all(['legacy = ?', true])
  end

  desc 'Update all the articles that were uploaded from legacy system'
  task :update_all => :init do
    for article in ArticleUpload.where('legacy = ?', true)
      puts "-- Update article #{article.title}"
      article.update_content
      article.update_attributes!(:status => Article::ONLINE)
    end
  end
end