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

# Defines tags attached to articles.
# A tag is a simple string attached to an article.
# "Pre-defined" tags (not attached to any article)
# are used to define the list of available tags proposed to users.
# Each time a user creates a new tag for an article, it's replicated as a pre-defined tag.
# Each time an article is created, the list of "Pre-defined" tags is used in order to generate
# the tags for the article based on its content.
class Tag < ActiveRecord::Base
  belongs_to :article

  validates_presence_of :tag

  before_validation :update_tag

  # Setup accessible (or protected) attributes for the model.
  attr_accessible :article_id, 
                  :tag

  # Deletes one specific tag across all the articles.   
  def delete_all_references
    Tag.delete_all(['tag = ? and article_id is not null', self.tag])
  end

  # Returns pre-defined tags with count.
  def self.predefined_tags
    Tag.find_by_sql "select a.id
                     , a.tag
                     , count(*) as count_tag
                     from tags a
                     , tags b
                     where a.article_id is null 
                     and a.tag = b.tag 
                     and b.article_id is not null 
                     group by a.id, a.tag
                     order by a.tag"
  end

  # Returns unused tags.
  def self.unused_tags
    Tag.find_by_sql "select a.id
                     , a.tag
                     , 0 as count_tag
                     from tags a
                     where a.article_id is null 
                     and not exists (
                       select 1
                       from tags b
                       where a.tag = b.tag
                       and b.article_id is not null 
                     )
                     group by a.id, a.tag
                     order by a.tag"
  end

  # Creates search attribute from tag name.
  def create_search
    self.search = Article.create_search self.tag
  end

private

  # Updates the tag with lowercase.
  def update_tag
    self.tag = self.tag.strip unless self.tag.nil?
    self.tag = self.tag.downcase unless self.tag.nil?
    self.search = Article.create_search self.tag unless self.tag.nil?
  end
end