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
describe Request do
  context "Validations" do
    it { should_not have_valid(:email).when(nil, '') }
    it { should_not have_valid(:first_name).when(nil, '') }
    it { should_not have_valid(:last_name).when(nil, '') }

    it "should not be valid with a bad email" do
      request = FactoryGirl.build(:request, :email => "rien")
      request.should_not be_valid
      request.error_on(:email).should_not be_empty
    end
  end

  context "Scopes" do
    it "#to_s returns a description of the request" do
      request = FactoryGirl.create(:request)
      identifier = request.to_s
      identifier.should include(request.email)
    end
    
    it "#recipient_display returns the description of the recipient" do
      article = FactoryGirl.create(:article_email)
      article.status = Article::ONLINE
      article.save!
      request = FactoryGirl.create(:request, :recipient => article.uri)
      request.recipient_display.should include(article.title)
    end

    it "#header_to_csv returns description of the record in .csv" do
      Request.header_to_csv.length.should be >= 1
    end

    it "#to_csv returns a description of the donation in .csv" do
      request = FactoryGirl.create(:request)
      identifier = request.to_csv
      identifier.should include("Prenom")
      identifier.should include("Nom")
    end
  end

  context "Behavior" do
    it "#email_notification triggers an email notification" do
      article = FactoryGirl.create(:article_email)
      article.status = Article::ONLINE
      article.save!
      FactoryGirl.create(:user, :notification_message => true)
      request = FactoryGirl.create(:request, :recipient => article.uri)
      request.email_notification
    end
  end
end