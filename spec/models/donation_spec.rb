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
describe Donation do
  context "Validations" do
    it { should_not have_valid(:email).when(nil, '') }
    it { should_not have_valid(:first_name).when(nil, '') }
    it { should_not have_valid(:last_name).when(nil, '') }
    it { should_not have_valid(:address).when(nil, '') }
    it { should_not have_valid(:zip_code).when(nil, '') }
    it { should_not have_valid(:city).when(nil, '') }

    it "should not be valid with a bad email" do
      donation = FactoryGirl.build(:donation, :email => "rien")
      donation.should_not be_valid
      donation.error_on(:email).should_not be_empty
    end

    it "should not be valid with an amount below the minimum" do
      donation = FactoryGirl.build(:donation, :amount => 2.0)
      donation.should_not be_valid
      donation.error_on(:amount).should_not be_empty
    end

    it "should not be valid with an amount above the maximum" do
      donation = FactoryGirl.build(:donation, :amount => 8000.0)
      donation.should_not be_valid
      donation.error_on(:amount).should_not be_empty
    end
  end

  context "Scopes" do
    it "#amount_cents returns the amount as cents" do
      donation = FactoryGirl.create(:donation, :amount => 36.0)
      donation.amount_cents.should be == "3600"
    end

    it "#payment_identifier returns a unique identifier" do
      donation = FactoryGirl.create(:donation)
      identifier = donation.payment_identifier
      identifier.length.should be >= 10
      identifier.should start_with "D"
      identifier.should include("PRENOM")
      identifier.should include("NOM")
    end

    it "#payment_ok? returns true when the payment was validated" do
      donation = FactoryGirl.create(:donation_paid)
      donation.payment_ok?.should be_true
      donation.payment_identifier.should_not be_nil
    end

    it "#payment_ok? returns false when the payment was not validated" do
      donation = FactoryGirl.create(:donation_error)
      donation.payment_ok?.should be_false
    end

    it "#payment_error_display returns OK when the payment was validated" do
      donation = FactoryGirl.create(:donation_paid)
      donation.payment_error_display.should be == "OK"
    end

    it "#payment_error_display returns ER when the payment was validated" do
      donation = FactoryGirl.create(:donation_error)
      donation.payment_error_display.should start_with "ER"
    end

    it "#find_paid returns a list of paid donations" do
      10.times {
        FactoryGirl.create(:donation_paid)
      }
      Donation.find_paid.length.should be == 10
    end

    it "#find_unpaid returns a list of unpaid donations" do
      10.times {
        FactoryGirl.create(:donation_error)
      }
      Donation.find_unpaid.length.should be == 10
    end

    it "#to_s returns a description of the donation" do
      donation = FactoryGirl.create(:donation)
      identifier = donation.to_s
      identifier.should include(donation.email)
      identifier.should include("PRENOM")
      identifier.should include("NOM")
      identifier.should include(" NO ")
    end

    it "#header_to_csv returns description of the record in .csv" do
      Donation.header_to_csv.length.should be >= 1
    end

    it "#to_csv returns a description of the donation in .csv" do
      donation = FactoryGirl.create(:donation)
      identifier = donation.to_csv
      identifier.should include(donation.email)
      identifier.should include("Prenom")
      identifier.should include("Nom")
      identifier.should include("PRENOM")
      identifier.should include("NOM")
      identifier.should include("50.0")
    end
  end

  context "Behavior" do
    it "#email_notification triggers an email notification" do
      FactoryGirl.create(:user, :notification_donation => true)
      donation = FactoryGirl.create(:donation)
      donation.email_notification
    end
  end
end