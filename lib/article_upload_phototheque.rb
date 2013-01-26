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

# Defines methods used to upload articles from legacy system.
class ArticleUploadPhototheque < Article
  include ActionView::Helpers::NumberHelper
  
  @@count = 0
  @@count_folders = 0
  COUNT_MAX = 100
  
  def self.init
    config = YAML::load(File.open('config/cmis.yml'))["phototheque"]
    print "Connect to repository..."; STDOUT.flush
    repository = ActiveCMIS.connect config
    puts "OK"
    print "Access to workspace..."; STDOUT.flush
    folder = repository.object_by_id config["workspace"], 
                                      {"renditionFilter" => "*", 
                                       "includeAllowableActions" => "true", 
                                       "includeACL" => false}
    puts "OK"
    folder
  end
  
  def self.upload_parent(parent_folder, objectId, title, category = 'diaporama')
    parent = find_by_external_id(objectId)
    if parent.nil?
      begin
        parent = new(:category => category,
                     :external_id => objectId,
                     :title => title,
                     :parent_id => parent_folder.nil? ? nil : parent_folder.id,
                     :published_at => Date.current,
                     :expired_at => Date.current + 99.year,
                     :status => NEW,
                     :created_by => "[photosdegauche.fr]",
                     :updated_by => "[photosdegauche.fr]")
        parent.transaction do
          parent.save!
          parent.save!
          parent.create_audit! parent.status, parent.updated_by
        end
      rescue Exception => invalid
        puts "Invalid=#{invalid.inspect}"
      end
    end
    parent
  end

  def self.upload_image(parent, objectId, uri, title, file_name, signature, category = 'image')
    article = find_by_external_id(objectId)
    if article.nil?
      begin
        file = File.open(file_name)
        article = new(:category => category,
                      :external_id => objectId,
                      :uri => uri,
                      :title => title,
                      :parent_id => parent.id,
                      :signature => "photosdegauche.fr" + 
                                    (signature.blank? ? "" : " (#{signature})"),
                      :published_at => Date.current,
                      :expired_at => Date.current + 99.year,
                      :status => NEW,
                      :created_by => "[photosdegauche.fr]",
                      :updated_by => "[photosdegauche.fr]")
        article.transaction do
          article.save!
          article.uri = uri
          article.image = file
          article.save!
          article.status = ONLINE
          article.save!
          article.create_audit! article.status, article.updated_by
        end
      rescue Exception => invalid
        puts "Invalid=#{invalid.inspect}"
      end
    end
    parent
  end

  def self.upload(folder, parent_folder=nil, root=true)
    return if @@count > COUNT_MAX
    start_total = Time.now
    if folder.is_a?(ActiveCMIS::Folder)
      parent = upload_parent parent_folder, folder.attributes["cmis:objectId"], folder.name
      for node in folder.items
        if node.is_a?(ActiveCMIS::Document) and node.cmis.contentStreamLength < 4.megabyte
          objectId = node.attributes["cmis:objectId"]
          article = find_by_external_id(objectId)
          if article.nil?
            start = Time.now
            file_name = "tmp/#{self.clean_filename(node.attributes["cmis:contentStreamFileName"])}"
            if file_name =~ /(.*)(.jpg|.jpeg|.gif|.png)/i
              uri = clean_uri(folder.name) + "-" + node.name
              signature = node.attributes["cmis:createdBy"]
              print "#{@@count+1}: #{uri}..."; STDOUT.flush
              print "download #{file_name}..."; STDOUT.flush
              node.content_stream.get_file(file_name)
              if File.exist?(file_name)
                print "upload..."; STDOUT.flush
                upload_image parent, objectId, uri, node.name, file_name, signature
                File.delete file_name
                elapsed = (Time.now - start).ceil
                puts "OK (#{elapsed} s)"
                @@count = @@count + 1
                break if @@count > COUNT_MAX
              else
                puts "File not found!"
              end
            end
          end
        end
        upload(node, parent, false) if node.is_a?(ActiveCMIS::Folder)
      end
    end
    if root
      elapsed_total_sec = (Time.now - start_total).ceil
      elapsed_total_min = ((Time.now - start_total)/60).ceil
      average_total = (elapsed_total_sec / COUNT_MAX).ceil
      speed = (60 * COUNT_MAX / elapsed_total_sec).ceil
      puts "Total elapsed time=#{elapsed_total_min} min, 
            average elapsed time=#{average_total} s/file, speed=#{speed} files/min"
    end
  end

  def self.select(folder, root=true)
    start_total = Time.now
    if folder.is_a?(ActiveCMIS::Folder)
      @@count_folders = @@count_folders + 1
      for node in folder.items
        if node.is_a?(ActiveCMIS::Document) and node.cmis.contentStreamLength
          @@count = @@count + 1
          puts "#{@@count}: #{node.name} - " +
               "cmis:objectId=#{node.attributes["cmis:objectId"]} " +
               "cmis:createdBy=#{node.attributes["cmis:createdBy"]} " +
               "cmis:contentStreamMimeType=#{node.attributes["cmis:contentStreamMimeType"]} " +
               "cmis:path=#{folder.attributes["cmis:path"]} " +
               "cmis:contentStreamFileName=#{node.attributes["cmis:contentStreamFileName"]} " +
               "cmis:contentStreamLength=#{node.attributes["cmis:contentStreamLength"]} " +
               "cmis:lastModificationDate=#{node.attributes["cmis:lastModificationDate"]}"
          puts "#{node.attributes.inspect}"
        end
        select(node, false) if node.is_a?(ActiveCMIS::Folder)
      end
    end
    if root
      elapsed_total_min = ((Time.now - start_total)/60).ceil
      puts "Total elapsed time=#{elapsed_total_min} min, 
            files=#{@@count}, folders=#{@@count_folders}"
    end
  end

  # Returns a clean file name given as parameter.
  def self.clean_filename(filename)
    filename.downcase.
        gsub(/[ '’\/]/,"-").
        gsub(/[àâäÀÂÄ]/,"a").
        gsub(/[éèêëÉÈÊË]/,"e").
        gsub(/[ìîïÌÎÏ]/,"i").
        gsub(/[òôöÒÔÖ]/,"o").
        gsub(/[ùûüÙÛÜ]/,"u").
        gsub(/[çÇ]/,"c").
        gsub(/[œŒ]/,"oe").
        gsub(/[^a-z0-9-.]/,"").
        gsub(/-{2,}/,"-").
        gsub(/-\z/,"\\1")
  end
end