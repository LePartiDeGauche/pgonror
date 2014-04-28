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

# Defines methods used to import content from Google Calendar.
class ArticleGooglecalendar < Article
  
  require 'open-uri'
  require "rexml/document"
  
  EVENT_TEMPLATE = /When: ([^<]+)\s*to\s*([^<]*)(.*)/
  EVENT_TEMPLATE_SIMPLE = /When: ([^<]+)\s*([^<]*)(.*)/
  EVENT_TEMPLATE_ADDRESS = /(.*)Where: ([^<]+)(.*)/
  EVENT_TIMEZONE = /.*(CET|CEST).*/

  # Import articles from an .xml stream.
  def self.import(import_file_name)
    file = File.new(import_file_name, "r:utf-8")
    xml_doc = REXML::Document.new file
    xml_doc.elements.each do |xml_root| 
      xml_root.elements.each do |xml_record| 
        if "entry" == xml_record.name 
          import_id = nil
          import_title = nil
          import_signature = nil
          import_published = nil
          import_startdatetime = nil
          import_endtime = nil
          import_all_day = false
          import_no_endtime = false
          import_address = nil
          xml_record.elements.each do |xml_column| 
            if "id" == xml_column.name
              text = xml_column.get_text
              if text.present?
                import_id = text.value
              end
            elsif "published" == xml_column.name
              text = xml_column.get_text
              if text.present?
                import_published = Date::parse CGI::unescapeHTML text.value
              end
            elsif "title" == xml_column.name
              text = xml_column.get_text
              if text.present?
                import_title = CGI::unescapeHTML text.value.gsub(/(\r|\n)/, "");
              end
            elsif "content" == xml_column.name
              text = xml_column.get_text
              if text.present?
                value = CGI::unescapeHTML text.value.gsub(/(\r|\n)/, "");
                if value.match(EVENT_TEMPLATE)
                  timezone = value.match(EVENT_TIMEZONE) ? value.gsub(EVENT_TIMEZONE, "\\1") : ""
                  import_startdatetime = DateTime::parse(CGI::unescapeHTML(value.gsub(EVENT_TEMPLATE, "\\1") + " " + timezone))            
                  import_endtime = Time::parse(CGI::unescapeHTML(value.gsub(EVENT_TEMPLATE, "\\2") + " " + timezone))
                  import_endtime = DateTime.new(import_startdatetime.year,
                                                import_startdatetime.month,
                                                import_startdatetime.mday,
                                                import_endtime.hour,
                                                import_endtime.min,
                                                import_endtime.sec,
                                                import_startdatetime.zone) if import_startdatetime.present? and import_endtime.present?
                  import_no_endtime = true if import_endtime.nil? or import_endtime.hour == 0 and import_endtime.min == 0
                elsif value.match(EVENT_TEMPLATE_SIMPLE)
                  begin
                    timezone = value.match(EVENT_TIMEZONE) ? value.gsub(EVENT_TIMEZONE, "\\1") : ""
                    import_startdatetime = DateTime::parse(CGI::unescapeHTML(value.gsub(EVENT_TEMPLATE_SIMPLE, "\\1") + " " + timezone))            
                    import_all_day = true if import_startdatetime.nil? or import_startdatetime.hour == 0 and import_startdatetime.min == 0
                    import_no_endtime = true
                  rescue ArgumentError => invalid
                    import_startdatetime = nil
                    import_no_endtime = false
                    import_all_day = false
                  end
                end
                if value.match(EVENT_TEMPLATE_ADDRESS)
                  import_address = CGI::unescapeHTML value.gsub(EVENT_TEMPLATE_ADDRESS, "\\2")
                end
              end
            elsif "author" == xml_column.name
              xml_column.elements.each do |xml_detail|
                if "name" == xml_detail.name
                  text = xml_detail.get_text
                  if text.present?
                    import_signature = CGI::unescapeHTML(text.value)
                  end
                end
              end 
            end
          end
          if import_id.present? and 
                import_startdatetime.present? and
                import_title.present? and
                import_startdatetime >= Date.current
            category = 'evenement'
            article = find_by_external_id(import_id)
            begin
              if article.nil?
                print "New #{import_title}..."; STDOUT.flush
                article = new(:external_id => import_id,
                              :category => category,
                              :title => import_title,
                              :published_at => import_published,
                              :expired_at => Date.current + 99.year,
                              :start_datetime => import_startdatetime, 
                              :end_datetime => import_endtime.nil? ? nil : import_endtime,
                              :all_day => import_all_day,
                              :no_endtime => import_no_endtime,
                              :address => import_address.nil? ? nil : import_address,
                              :status => NEW,
                              :created_by => "[Importation Google Calendar]",
                              :updated_by => "[Importation Google Calendar]")
                article.transaction do
                  article.save!
                  # Double-save is required in order to retrieve article.id
                  article.save!
                  article.status = ONLINE
                  article.save!
                  article.create_audit! article.status, article.updated_by
                end
                puts "OK"
              elsif article.title != import_title or
                    article.start_datetime != import_startdatetime or
                    article.end_datetime != import_endtime or
                    article.no_endtime != import_no_endtime or
                    article.all_day != import_all_day or
                    article.address != import_address
                print "Update #{import_title}..."; STDOUT.flush
                article.title = import_title
                article.published_at = import_published
                article.start_datetime = import_startdatetime
                article.end_datetime = import_endtime.nil? ? nil : import_endtime
                article.all_day = import_all_day
                article.no_endtime = import_no_endtime
                article.address = import_address.nil? ? nil : import_address
                article.updated_by = "[Importation Google Calendar]"
                article.transaction do
                  article.save!
                  article.create_audit! article.status, article.updated_by
                end
                puts "OK"
              end
            rescue Exception => invalid
              puts "Invalid=#{invalid.inspect}"
            end
          end
        end
      end
    end
  end
end
