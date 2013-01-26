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
class ArticleUpload < Article
  
  require 'open-uri'
  require "rexml/document"

  # Uploads legacy articles from an .xml file.
  def self.upload_legacy(import_file_name)
    file = File.new(import_file_name, "r:utf-8")
    xml_doc = REXML::Document.new file
    xml_doc.elements.each do |xml_root| 
      xml_root.elements.each do |xml_record| 
        if "row" == xml_record.name 
          legacy_id = nil
          legacy_section_alias = nil
          legacy_category_alias = nil
          legacy_alias = nil
          legacy_title = nil
          legacy_created_by_alias = nil
          legacy_introtext = nil
          legacy_fulltext = nil
          legacy_dates = nil
          legacy_times = nil
          legacy_endtimes = nil
          legacy_venue = nil
          legacy_street = nil
          legacy_plz = nil
          legacy_city = nil
          legacy_country = nil
          legacy_created = nil
          xml_record.elements.each do |xml_column| 
            if "field" == xml_column.name
              value = undecode xml_column.get_text
              if value.present? and value != '' and value != 'NULL'
                case xml_column.attributes['name']
                  when 'id' then legacy_id = value
                  when 'section_alias' then legacy_section_alias = value
                  when 'category_alias' then legacy_category_alias = value
                  when 'alias' then legacy_alias = value
                  when 'title' then legacy_title = value
                  when 'created_by_alias' then legacy_created_by_alias = value
                  when 'introtext' then legacy_introtext = value
                  when 'fulltext' then legacy_fulltext = value
                  when 'dates' then legacy_dates = Date::parse value
                  when 'times' then legacy_times = Time::parse value
                  when 'endtimes' then legacy_endtimes = Time::parse value
                  when 'venue' then legacy_venue = value
                  when 'street' then legacy_street = value
                  when 'plz' then legacy_plz = value
                  when 'city' then legacy_city = value
                  when 'country' then legacy_country = value
                  when 'created' then legacy_created = DateTime::parse value
                end
              end
            end
          end
          if legacy_id.present? and 
             legacy_section_alias.present? and 
             legacy_category_alias.present? and
             legacy_alias.present? and
             legacy_title.present?
            category = nil
            if "4109-lhumain-dabord-programme-du-front-de-gauche" == legacy_alias or
                  "3049-programme-partage-du-front-de-gauche-des-propositions-et-une-methode" == legacy_alias
              category = 'programme' 
            elsif ("en-france" == legacy_section_alias and "actualites" == legacy_category_alias) or
                  ("front-de-gauche" == legacy_section_alias)
              category = 'actu'
              category = 'com' if legacy_title.downcase.match(/^communiqu/) or 
                                        (legacy_introtext.present? and legacy_introtext.downcase.match(/^communiqu/)) or
                                        (legacy_fulltext.present? and legacy_fulltext.downcase.match(/^communiqu/))
            elsif "en-france" == legacy_section_alias and "editoriaux" == legacy_category_alias
              category = 'edito' 
            elsif "en-france" == legacy_section_alias and "arguments" == legacy_category_alias
              category = 'argument' 
              category = 'dossier' if legacy_title.downcase.match(/^dossier/)
            elsif "echanges" == legacy_section_alias and 
                  "notre-reseau-de-blogs" == legacy_category_alias and
                  not legacy_title.downcase.match(/^commentaire/)
              category = 'directblog' 
            elsif "international" == legacy_section_alias and 
              ("linternationale-de-lautre-gauche" == legacy_category_alias or
               "actualite" == legacy_category_alias)
              category = 'inter' 
              category = 'web' if legacy_created_by_alias.present? and legacy_created_by_alias.downcase.match(/^trad/) 
            elsif "international" == legacy_section_alias and "vue-dailleurs" == legacy_category_alias
              category = 'web'
            elsif "vie-du-pg" == legacy_section_alias and "dans-les-departements" == legacy_category_alias
              category = 'articlevdg'  
            elsif "vie-du-pg" == legacy_section_alias and "elus" == legacy_category_alias
              category = 'articlevdg'  
            elsif "vie-du-pg" == legacy_section_alias and "vie-de-gauche" == legacy_category_alias
              category = 'vdg'  
            elsif "chroniques" == legacy_section_alias
              category = 'vdg'  
            elsif "vie-du-parti" == legacy_section_alias and "publications" == legacy_category_alias
              category = 'livre'  
            elsif "vie-du-parti" == legacy_section_alias
              category = 'articlevdg'  
            elsif "education-populaire" == legacy_section_alias and "une-date" == legacy_category_alias
              category = 'date' 
            elsif "education-populaire" == legacy_section_alias and "a-gauche-la-revue" == legacy_category_alias
              category = 'revue' 
            elsif "education-populaire" == legacy_section_alias and "ateliers-de-lecture" == legacy_category_alias
              category = 'lecture' 
            elsif "formation" == legacy_section_alias and "vendredis" == legacy_category_alias
              category = 'vendredi' 
            elsif "militons" == legacy_section_alias and "affiches" == legacy_category_alias
              category = 'affiche' 
            elsif "militons" == legacy_section_alias and "tracts" == legacy_category_alias
              category = 'tract' 
            elsif "militons" == legacy_section_alias and "campagnes-en-ligne" == legacy_category_alias
              category = 'campagne_enligne' 
            elsif "militons" == legacy_section_alias and "tracts" == legacy_category_alias
              category = 'tract' 
            elsif "le-parti-de-gauche" == legacy_section_alias and "contacts-locaux" == legacy_category_alias
              category = 'departement' 
            elsif "le-parti-de-gauche" == legacy_section_alias and "les-instances-nationales-du-pg" == legacy_category_alias
              category = 'instance' 
              category = 'commission' if legacy_title.downcase.match(/^les commissions/)
            elsif "le-parti-de-gauche" == legacy_section_alias and "notre-identite" == legacy_category_alias
              category = 'identite' 
            elsif "videos" == legacy_section_alias
              category = 'video' 
            elsif "adherents" == legacy_section_alias and "circulaires" == legacy_category_alias
              category = 'circulaire' 
            elsif "adherents" == legacy_section_alias and "documents-utiles" == legacy_category_alias
              category = 'doc-utile' 
            elsif "adherents" == legacy_section_alias and "conseils-du-doc" == legacy_category_alias
              category = 'conseil'
            else 
              category = 'divers'
            end
            if category.present?
              begin
                article = find_by_uri(legacy_alias)
                if article.nil?
                  print "New #{legacy_id}:#{legacy_title}..." ; STDOUT.flush
                  article = new(:category => category,
                                 :uri => legacy_alias,
                                 :legacy => true,
                                 :title => legacy_title,
                                 :published_at => legacy_created,
                                 :expired_at => Date.current + 99.year,
                                 :status => NEW,
                                 :signature => legacy_created_by_alias,
                                 :content => updated_content(legacy_introtext + legacy_fulltext),
                                 :created_by => "[Reprise de données]",
                                 :updated_by => "[Reprise de données]")
                  article.transaction do
                    article.save!
                    article.status = ONLINE
                    article.save!
                    article.create_audit! article.status, article.updated_by
                  end
                  puts "OK"
                elsif article.title != legacy_title
                  print "Update #{legacy_id}:#{legacy_title}..." ; STDOUT.flush
                  article.title = legacy_title
                  article.signature = legacy_created_by_alias
                  article.content = updated_content(legacy_introtext + legacy_fulltext)
                  article.updated_by = "[Reprise de données]"
                  article.transaction do
                    article.save!
                    article.create_audit! article.status, article.updated_by
                  end
                  puts "OK"
                end
              rescue ActiveRecord::RecordInvalid => invalid
                puts "Invalid=#{invalid.inspect}"
              end
            end
          elsif legacy_id.present? and 
                legacy_dates.present? and
                legacy_alias.present? and
                legacy_title.present?
            category = 'evenement'
            if find_by_uri(legacy_alias).nil?
              address = legacy_venue.present? ? legacy_venue : ""
              address << ("," + legacy_street) unless legacy_street.blank?
              address << ("," + legacy_plz) unless legacy_plz.blank?
              address << ("," + legacy_city) unless legacy_city.blank?
              begin
                print "#{legacy_id}:#{legacy_title}..."; STDOUT.flush
                article = new(:category => category,
                              :uri => legacy_alias,
                              :legacy => true,
                              :title => legacy_title,
                              :published_at => legacy_created,
                              :expired_at => Date.current + 99.year,
                              :address => address,
                              :start_datetime => DateTime.civil(legacy_dates.year, 
                                                                legacy_dates.month, 
                                                                legacy_dates.day, 
                                                                legacy_times.present? ? legacy_times.hour : 0, 
                                                                legacy_times.present? ? legacy_times.min : 0), 
                              :end_datetime => legacy_endtimes,
                              :status => NEW,
                              :created_by => "[Reprise de données]",
                              :updated_by => "[Reprise de données]")
                article.transaction do
                  article.save!
                  article.status = ONLINE
                  article.save!
                  article.create_audit! article.status, article.updated_by
                end
                puts "OK"
              rescue Exception => invalid
                puts "Invalid=#{invalid.inspect}"
              end
            end
          end
        end
      end
    end
  end
  
  # Uploads legacy files (images and documents) from file server directory.
  def self.upload_legacy_documents(parent_name, title, dir, category = 'directory')
    parent = find_by_uri(parent_name)
    if parent.nil?
      begin
        print "#{category}:#{parent_name}..."; STDOUT.flush
        parent = new(:category => category,
                     :uri => parent_name,
                     :legacy => true,
                     :title => title,
                     :published_at => Date.current,
                     :expired_at => Date.current + 99.year,
                     :status => NEW,
                     :created_by => "[Reprise de données]",
                     :updated_by => "[Reprise de données]")
        parent.transaction do
          parent.save!
          parent.status = ONLINE
          parent.save!
          parent.create_audit! parent.status, parent.updated_by
        end
        puts "OK"
      rescue Exception => invalid
        puts "Invalid=#{invalid.inspect}"
      end
    end
    Dir.foreach(dir) {|file_name| 
      uri = parent_name + "-" + file_name
      if file_name =~ /(.*)(.jpg|.jpeg|.gif|.png|.JPG|.JPEG|.PNG|.GIF)/
        file = File.open(dir + file_name)
        if find_by_uri(uri).nil?
          begin
            print "#{dir}#{file_name}..."; STDOUT.flush
            article = new(:category => 'image',
                          :uri => uri,
                          :legacy => true,
                          :title => file_name,
                          :parent_id => parent.id,
                          :image => file,
                          :published_at => Date.current,
                          :expired_at => Date.current + 99.year,
                          :status => NEW,
                          :created_by => "[Reprise de données]",
                          :updated_by => "[Reprise de données]")
            article.transaction do
              article.save!
              article.status = ONLINE
              article.save!
              article.create_audit! article.status, article.updated_by
            end
            puts "OK"
          rescue Exception => invalid
            puts "Invalid=#{invalid.inspect}"
          end
        end
      elsif file_name =~ /(.*)(.pdf|.doc|.rtf|.odt|.PDF|.DOC|.RTF|.ODT)/
        file = File.open(dir + file_name)
        if find_by_uri(uri).nil?
          begin
            print "#{dir}#{file_name}..."
            article = new(:category => 'document',
                          :uri => uri,
                          :legacy => true,
                          :title => file_name,
                          :parent_id => parent.id,
                          :document => file,
                          :published_at => Date.current,
                          :expired_at => Date.current + 99.year,
                          :status => NEW,
                          :created_by => "[Reprise de données]",
                          :updated_by => "[Reprise de données]")
            article.transaction do
              article.save!
              article.status = ONLINE
              article.save!
              article.create_audit! article.status, article.updated_by
            end
            puts "OK"
          rescue Exception => invalid
            puts "Invalid=#{invalid.inspect}"
          end
        end
      end
    }
  end
  
  def self.update_sources
    for article in ArticleUpload.where('category = ? and status = ?', 
                                       'directblog',  ONLINE).order('id')
      id = article.id
      print "Remove duplicates #{article.title}"; STDOUT.flush
      for dup in ArticleUpload.where('category = ? and status = ? and title = ? and id > ?', 
                                     'directblog',  ONLINE, article.title, id).order('published_at desc, updated_at desc')
        print "."; STDOUT.flush
        dup.updated_by = "[Reprise de données]"
        dup.status = OFFLINE
        dup.transaction do
          dup.save!
          dup.create_audit! dup.status, dup.updated_by
        end
      end
      puts ""
      article = ArticleUpload.find_by_id id
      if article.status == ONLINE and article.source_id.nil?
        print " - Update..."; STDOUT.flush
        for source in ArticleUpload.where('category = ? and status = ? and source_id is null and content is not null', 
                                          'blog',  ONLINE)
          url = source.content.gsub(/(.*)href="http(s?):\/(.*)"(.*)/, "http\\2:/\\3")
          if (article.content.present? and article.content[url].present?)
           article.source_id = source.id
           article.updated_by = "[Reprise de données]"
           article.transaction do
             article.save!
             article.create_audit! article.status, article.updated_by
           end
           puts "OK"
           break
          end
        end
        puts " !" if article.source_id.nil?
      end
    end
  end

  # Uploads legacy videos from an .xml file.
  def self.upload_videos(import_file_name)
    file = File.new(import_file_name, "r:utf-8")
    xml_doc = REXML::Document.new file
    xml_doc.elements.each do |xml_root| 
      xml_root.elements.each do |xml_record| 
        if "row" == xml_record.name 
          legacy_id = nil
          legacy_rubrique = nil
          legacy_departement = nil
          legacy_published = nil
          legacy_video = nil
          legacy_title = nil
          legacy_introtext = ""
          legacy_fulltext = ""
          xml_record.elements.each do |xml_column| 
            if "field" == xml_column.name
              value = undecode xml_column.get_text
              if value.present? and value != '' and value != 'NULL'
                case xml_column.attributes['name']
                  when 'id' then legacy_id = value
                  when 'rubrique' then legacy_rubrique = value
                  when 'departement' then legacy_departement = value
                  when 'video' then legacy_video = value
                  when 'title' then legacy_title = value.strip
                  when 'introduction' then legacy_introtext = value
                  when 'content' then legacy_fulltext = value
                  when 'published' then legacy_published = DateTime::parse value
                end
              end
            end
          end
          if legacy_id.present? and 
             legacy_rubrique.present? and 
             legacy_departement.present? and
             legacy_video.present? and
             legacy_title.present?
            if legacy_rubrique == "Front de Gauche"
              case legacy_departement
                when "Agitation et Propagande" then category = "videoagitprop"
                when "Analyses politiques et électorales" then category = "videoweb"
                when "Entretiens" then category = "videoweb"
                when "Meetings" then category = "conference"
                when "Bataille idéologique" then category = "videoweb"
                when "Conférences et Débats" then category = "conference"
                when "Grèves, manifs et déplacements" then category = "videoevenement"
                when "Remue-Méninges" then category = "videoeduc"
                when "Web-série" then category = "encampagne"
              end 
            elsif legacy_rubrique == "Télé de Gauche 77"
              case legacy_departement
                when "Agitation et Propagande" then category = "videoagitprop"
                when "Analyses politiques et électorales" then category = "videoweb"
                when "Entretiens" then category = "videoeduc"
                when "Meetings" then category = "conference"
                when "Bataille idéologique" then category = "media"
                when "Conférences et Débats" then category = "conference"
                when "Grèves, manifs et déplacements" then category = "videoevenement"
                when "Remue-Méninges" then category = "videoeduc"
                when "Web-série" then category = "encampagne"
              end 
            else
              case legacy_departement
                when "Agitation et Propagande" then category = "videoagitprop"
                when "Analyses politiques et électorales" then category = "videoweb"
                when "Entretiens" then category = "videoeduc"
                when "Meetings" then category = "conference"
                when "Bataille idéologique" then category = "media"
                when "Conférences et Débats" then category = "conference"
                when "Grèves, manifs et déplacements" then category = "videoevenement"
                when "Remue-Méninges" then category = "videoeduc"
                when "Web-série" then category = "encampagne"
                when "Vendredis du PG" then category = "videoeduc"
                else category = "video"
              end 
              legacy_rubrique = "Télé de Gauche"
            end
            legacy_alias = clean_uri(legacy_title + "-" + legacy_id)
            if legacy_video.present?
              legacy_video = "<br/>{dmotion}#{legacy_video}{/dmotion}"
            else
              legacy_video = ""
            end
            if category.present?
              begin
                article = find_by_uri(legacy_alias)
                if article.nil?
                  print "New #{legacy_id}:#{legacy_alias}..." ; STDOUT.flush
                  article = new(:category => category,
                                 :uri => legacy_alias,
                                 :legacy => true,
                                 :heading => legacy_departement,
                                 :show_heading => true,
                                 :title => legacy_title,
                                 :published_at => legacy_published,
                                 :expired_at => Date.current + 99.year,
                                 :status => NEW,
                                 :signature => legacy_rubrique,
                                 :content => updated_content(legacy_introtext + legacy_video + legacy_fulltext),
                                 :created_by => "[Reprise de données TeleDeGauche]",
                                 :updated_by => "[Reprise de données TeleDeGauche]")
                  article.transaction do
                    article.save!
                    article.status = ONLINE
                    article.save!
                    article.create_audit! article.status, article.updated_by
                  end
                  puts "OK"
                end
              rescue ActiveRecord::RecordInvalid => invalid
                puts "Invalid=#{invalid.inspect}"
              end
            end
          end
        end
      end
    end
  end

  # Uploads RSS flow from an .xml file.
  def self.upload_rss(import_file_name, rss_category)
    file = File.new(import_file_name, "r:utf-8")
    xml_doc = REXML::Document.new file
    xml_doc.elements.each do |xml_rss|
      xml_rss.elements.each do |xml_channel| 
        if "channel" == xml_channel.name
          rss_signature = nil
          rss_source = nil
          xml_channel.elements.each do |xml_item|
            if "description" == xml_item.name
              rss_signature = undecode xml_item.get_text
            elsif "link" == xml_item.name
              rss_link = undecode xml_item.get_text
              rss_source = find_by_external_id(rss_link)
            elsif "item" == xml_item.name 
              rss_id = nil
              rss_title = nil
              rss_description = nil
              rss_guid = nil
              rss_published_at = nil
              xml_item.elements.each do |xml_attribute|
                value = undecode xml_attribute.get_text
                case xml_attribute.name
                  when 'guid' then rss_guid = value
                  when 'title' then rss_title = value
                  when 'description' then rss_description = value
                  when 'pubDate' then rss_published_at = DateTime::parse(value)
                end
              end
              puts "item rss_guid=#{rss_guid}, rss_title=#{rss_title}"
              if rss_guid.present? and
                 rss_title.present? and
                 rss_description.present? and
                 rss_signature.present? and
                 rss_source.present? and
                 rss_published_at.present?
                begin
                  article = find_by_external_id(rss_guid)
                  if article.nil?
                    print "New #{rss_title}..." ; STDOUT.flush
                    rss_description << "<p><a href=\"#{rss_guid}\">Voir l'article original</a></p>"
                    article = new(:category => rss_category,
                                  :title => rss_title,
                                  :published_at => rss_published_at,
                                  :expired_at => Date.current + 99.year,
                                  :source_id => rss_source.id,
                                  :status => NEW,
                                  :signature => rss_signature,
                                  :external_id => rss_guid,
                                  :content => updated_content(rss_description),
                                  :created_by => "[Syndication RSS]",
                                  :updated_by => "[Syndication RSS]")
                    article.transaction do
                      article.save!
                      article.status = ONLINE
                      article.save!
                      article.create_audit! article.status, article.updated_by
                    end
                    puts "OK"
                  end
                rescue ActiveRecord::RecordInvalid => invalid
                  puts "Invalid=#{invalid.inspect}"
                end
              end
            end
          end
        end
      end
    end
  end

private

  # Updates content of uploaded articles: fixes typos and updates references to images and documents .
  def self.updated_content(content)
    return nil if content.nil?
    correct_french_typos(
      content.gsub(/src="(.*)images\/stories\/(illustrations|tracts|vdg|circulaires|adl|revue-a-gauche|gavroche|affiches|formations|docs-pg|video|textes|logos|)\/(.*)(.jpg|.jpeg|.png|.gif|.JPG|.JPEG|.PNG|.GIF)"/,"src=\"/system/images/inline/\\2-\\3\\4\"").
              gsub(/href="(.*)images\/stories\/(illustrations|tracts|vdg|circulaires|adl|revue-a-gauche|gavroche|affiches|formations|docs-pg|video|textes|logos|)\/(.*)(.pdf|.doc|.rtf|.odt|.PDF|.DOC|.RTF|.ODT)"/,"href=\"/system/documents/\\2-\\3\\4\"").
              gsub(/src="(.*)images\/stories\/(.*)(.jpg|.jpeg|.png|.gif|.JPG|.JPEG|.PNG|.GIF)"/,"src=\"/system/images/inline/stories-\\2\\3\"").
              gsub(/href="(.*)images\/stories\/(.*)(.pdf|.doc|.rtf|.odt|.PDF|.DOC|.RTF|.ODT)"/,"href=\"/system/documents/stories-\\2\\3\"")
    )
  end

  # Undecodes strings from .xml file.
  def self.undecode(attribute)
    attribute.to_s.gsub(/&amp;/,'&').gsub(/&lt;/,'<').gsub(/&gt;/,'>').gsub(/&quot;/,'"')    
  end
end