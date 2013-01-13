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
describe User do
  context "Validations" do
    it { should_not have_valid(:email).when('') }

    it "email is unique" do
      user = FactoryGirl.create(:user, :email => "user@lepartidegauche.fr")
      user2 = FactoryGirl.build(:user, :email => "user@lepartidegauche.fr")
      user2.should_not be_valid
      user2.error_on(:email).should_not be_empty
    end

    it "should not be valid with a bad email" do
      user = FactoryGirl.build(:user, :email => "rien")
      user.should_not be_valid
      user.error_on(:email).should_not be_empty
    end
  end
  
  context "Scopes" do
    it "#access_levels returns a list of access levels" do
      User.access_levels.length.should be == 2
    end

    it "#access_level_display returns user's access level" do
      user = FactoryGirl.create(:user, :access_level => "reserved")
      user.access_level_display.should_not be_nil
    end

    it "#get_authorization_article returns publisher grants" do
      user = FactoryGirl.create(:publisher)
      FactoryGirl.create(:permission, :user => user)
      permission = User.get_authorization_article(user.email, "inter")
      permission.should_not be_nil
    end

    it "#find_like_email find a user based on an email" do
      FactoryGirl.create(:user, :email => "userA@lepartidegauche.fr")
      user = User.find_like_email("userA@lepartidegauche.fr")
      user.should_not be_nil
    end

    it "#notification_recipients returns a list of recipients for email notification" do
      3.times { FactoryGirl.create(:user, :notification_membership => true) }
      recipients = User.notification_recipients "notification_membership"
      recipients.length.should be == 3
    end
  end
  
  context "Behavior" do
    it "#notification_new_user triggers an email notification" do
      FactoryGirl.create(:administrator)
      user = FactoryGirl.create(:user)
      user.notification_new_user
    end
  end
end