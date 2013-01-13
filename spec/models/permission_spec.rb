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
describe Permission do
  context "Validations" do
    it { should_not have_valid(:category).when('') }
    it { should_not have_valid(:authorization).when('') }
    it { should_not have_valid(:updated_by).when(nil) }
  end

  context "Scopes" do
    it "#authorizations returns a list of authorization levels" do
      Permission.authorizations.length.should be == 3
    end

    it "#authorization_display returns the description of an authorization level" do
      Permission.authorization_display(Permission::REVIEWER).should_not be_nil
    end

    it "#authorization_display returns the description of an authorization level" do
      user = FactoryGirl.create(:publisher)
      permission = FactoryGirl.create(:permission, :user => user)
      permission.authorization_display.should_not be_nil
      permission.authorization_display.should_not be == ""
      permission.authorization_display.should_not be == "-"
    end

    it "#notifications returns a list of notifications levels" do
      Permission.notifications.length.should be == 2
    end

    it "#notification_level_display returns the description of an notification level" do
      user = FactoryGirl.create(:publisher)
      permission = FactoryGirl.create(:permission, :user => user)
      permission.notification_level_display.should be == "-"
      user = FactoryGirl.create(:publisher)
      permission = FactoryGirl.create(:permission, :user => user, :notification_level => Article::NEW)
      permission.notification_level_display.should_not be_nil
      permission.notification_level_display.should_not be == ""
      permission.notification_level_display.should_not be == "-"
      user = FactoryGirl.create(:publisher)
      permission = FactoryGirl.create(:permission, :user => user, :notification_level => Article::REVIEWED)
      permission.notification_level_display.should_not be_nil
      permission.notification_level_display.should_not be == ""
      permission.notification_level_display.should_not be == "-"
    end

    it "#source_display returns the source of the permission" do
      source = FactoryGirl.create(:article_source)
      article = FactoryGirl.create(:article, :source_id => source.id)
      user = FactoryGirl.create(:publisher)
      permission = FactoryGirl.create(:permission, :user => user, :source_id => article.id)
      permission.source_display.should_not be_nil
      permission.source_display.should_not be == ""
      permission.source_display.should_not be == "-"
    end

    it "#category_display returns the category of the permission" do
      user = FactoryGirl.create(:publisher)
      permission = FactoryGirl.create(:permission, :user => user)
      permission.category_display.should_not be_nil
      permission.category_display.should_not be == ""
      permission.category_display.should_not be == "-"
    end

    it "#notification_recipients returns a list of recipients for notification" do
      3.times {
        user = FactoryGirl.create(:publisher)
        FactoryGirl.create(:permission, :user => user, :notification_level => Article::NEW)
      }
      3.times {
        user = FactoryGirl.create(:publisher)
        FactoryGirl.create(:permission, :user => user, :notification_level => Article::REVIEWED)
      }
      permissions = Permission.notification_recipients(Article::NEW, "inter")
      permissions.length.should be == 3
      permissions = Permission.notification_recipients(Article::ONLINE, "inter")
      permissions.length.should be == 6
    end
  end
end