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
describe Subscription do
  context "Validations" do
    it { should_not have_valid(:email).when(nil, '') }
    it { should_not have_valid(:first_name).when(nil, '') }
    it { should_not have_valid(:last_name).when(nil, '') }

    it "should not be valid with a bad email" do
      subscription = FactoryGirl.build(:subscription, :email => "rien")
      subscription.should_not be_valid
      subscription.error_on(:email).should_not be_empty
    end
  end

  context "Scopes" do
    it "#to_s returns a description of the subscription" do
      subscription = FactoryGirl.create(:subscription)
      identifier = subscription.to_s
      identifier.should include("Prénom")
      identifier.should include("Nom")
    end
  end

  context "Behavior" do
    it "#email_notification triggers an email notification" do
      FactoryGirl.create(:user, :notification_subscription => true)
      subscription = FactoryGirl.create(:subscription)
      subscription.email_notification
    end
  end
end