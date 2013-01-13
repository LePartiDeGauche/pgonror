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
describe Audit do
  context "Validations" do
    it { should_not have_valid(:article_id).when(nil) }
    it { should_not have_valid(:updated_by).when(nil) }
  end

  context "Scopes" do
    it "#status_display returns a description of the status" do
      article = FactoryGirl.create(:article)
      article.create_audit!(article.status, article.updated_by, "Création")
      article.status = Article::ONLINE
      article.save!
      article.create_audit!(article.status, article.updated_by, "Publication")
      article.audits.length.should be == 2
      for audit in article.audits
        identifier = audit.status_display
        identifier.should_not be_nil
      end 
    end

    it "#to_s returns a description of the audit" do
      article = FactoryGirl.create(:article)
      article.create_audit!(article.status, article.updated_by, "Création")
      article.status = Article::ONLINE
      article.save!
      article.create_audit!(article.status, article.updated_by, "Publication")
      article.audits.length.should be == 2
      for audit in article.audits
        identifier = audit.to_s
        identifier.should include(article.title)
      end 
    end
  end
end