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
require 'spec_helper'
describe Tag do
  context "Validations" do
    it { should_not have_valid(:tag).when(nil, '') }
  end

  context "Scopes" do
    it "#predefined_tags returns pre-defined tags with count" do
      Article.create_default_tag("parti", "spec@lepartidegauche.fr")
      Article.create_default_tag("gauche", "spec@lepartidegauche.fr")
      article = FactoryGirl.create(:article, :content => "<p>Article très recherché du Parti de Gauche</p>")
      article.status = Article::ONLINE
      article.save!
      Tag.predefined_tags.length.should be == 2
    end

    it "#unused_tags returns unused tags" do
      Article.create_default_tag("parti de gauche", "spec@lepartidegauche.fr")
      Article.create_default_tag("front de gauche", "spec@lepartidegauche.fr")
      Tag.unused_tags.length.should be == 2
      article = FactoryGirl.create(:article, :content => "<p>Article très recherché du Parti de Gauche</p>")
      article.status = Article::ONLINE
      article.save!
      Tag.unused_tags.length.should be == 1
      article = FactoryGirl.create(:article, :content => "<p>Article très recherché du Front de Gauche</p>")
      article.status = Article::ONLINE
      article.save!
      Tag.unused_tags.length.should be == 0
    end
  end

  context "Behavior" do
    it "#delete_all_references deletes one specific tag across all the articles" do
      Article.create_default_tag("parti de gauche", "spec@lepartidegauche.fr")
      article = FactoryGirl.create(:article, :content => "<p>Article très recherché du Parti de Gauche</p>")
      article.status = Article::ONLINE
      article.save!
      article.tags.length.should be == 1
      tag = article.tags[0]
      tag.tag.should be == "parti de gauche"
      tag.delete_all_references
      article = Article.find_published_by_uri article.uri
      article.should_not be_nil
      article.tags.length.should be == 0
    end
  end
end