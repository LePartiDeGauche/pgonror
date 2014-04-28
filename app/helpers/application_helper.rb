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

# Application helper.
module ApplicationHelper
  # Returns a title for the web site based on the article being displayed.  
  def current_page_title
    t('general.title') + (@page_title.present? ? " » " + @page_title.to_s : "")
  end

  # Returns a title for the social networks.  
  def current_page_title_sn
    @page_title.present? ? @page_title.to_s : ""
  end

  # Returns a description for the web site based on the article being displayed.  
  def current_page_description
    @page_description.present? ? @page_description : "" 
  end

  # Displays an icon from the assets with a fixed size 12x12.
  def icon(name, title=nil)
    return "" if name.nil?
    tag("img", {:src => asset_path(name), 
                :alt => name,
                :height => "12", 
                :width => "12", 
                :title => title})
  end

  # Displays an icon from the assets with a fixed size 16x16.
  def icon_medium(name, title=nil)
    return "" if name.nil?
    tag("img", {:src => asset_path(name),
                :alt => name, 
                :height => "16", 
                :width => "16", 
                :title => title})
  end

  # Displays an icon from the assets with a fixed size 32x32.
  def icon_large(name, title=nil)
    return "" if name.nil?
    tag("img", {:src => asset_path(name),
                :alt => name, 
                :height => "32", 
                :width => "32", 
                :title => title})
  end

  # Displays a time and name.
  def display_time_by(who, time)
    t('general.time_by',
            :time => time_ago_in_words(time, :include_seconds => true),
            :by => (who.present?) ? who : t('general.unknown'))
  end

  # Returns true when the cache mechanism can be activated.
  def can_cache?
    not(user_signed_in?) and flash[:alert].nil? and flash[:notice].nil?
  end
end
