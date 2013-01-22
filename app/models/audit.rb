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

# Defines audit information attached to articles.
class Audit < ActiveRecord::Base
  belongs_to :article

  # Basic controls: mandatory attributes, uniqueness and formats.
  validates_presence_of :article_id, :updated_by

  # Setup accessible (or protected) attributes for the model.
  attr_accessible :article_id, 
                  :status,
                  :updated_by,
                  :comments

  # Returns the status (displayed label) of the audit record.  
  def status_display
    Article::status_display(self.status)
  end

  # Returns the content as a string used for display.  
  def to_s
    "#{I18n.l(updated_at)} : #{article.nil? ? '' : article.category_display} #{article.nil? ? '' : article} (#{updated_by}) #{status_display}".html_safe
  end

  # For logs in Administration panel
  scope :logs, order('updated_at DESC')
  scope :filtered_by, lambda { |search| where('lower(updated_by) LIKE ?', "%#{search.downcase.strip}%") }
end