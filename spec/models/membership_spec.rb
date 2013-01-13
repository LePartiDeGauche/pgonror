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
describe Membership do
  context "Validations" do
    it { should_not have_valid(:email).when(nil, '') }
    it { should_not have_valid(:department).when(nil, '', 'Sardaigne') }
    it { should have_valid(:department).when('Doubs (25)', 'Mayotte (976)') }
    it { should_not have_valid(:gender).when(nil, '', 'Martien') }
    it { should have_valid(:gender).when('Femme', 'Homme') }
    it { should_not have_valid(:first_name).when(nil, '') }
    it { should_not have_valid(:last_name).when(nil, '') }
    it { should_not have_valid(:address).when(nil, '') }
    it { should_not have_valid(:zip_code).when(nil, '') }
    it { should_not have_valid(:birthdate).when(nil) }
    it { should_not have_valid(:city).when(nil, '') }

    it "committee is mandatory when renewal" do
      member = FactoryGirl.build(:membership, :renew => true)
      member.should_not be_valid
      member.error_on(:committee).should_not be_empty
    end

    it "committee is captured when renewal" do
      member = FactoryGirl.build(:membership, :renew => true, :committee => "Paris 1")
      member.should be_valid
      member.save!
    end

    it "should not be valid when no phone number is captured" do
      member = FactoryGirl.build(:membership, :phone => nil, :mobile => nil)
      member.should_not be_valid
      member.error_on(:phone).should_not be_empty
      member.error_on(:mobile).should_not be_empty
    end

    it "should be valid when a phone number is captured" do
      member = FactoryGirl.build(:membership, :phone => "0102030405", :mobile => nil)
      member.should be_valid
      member.save!
    end

    it "should be valid when a mobile number is captured" do
      member = FactoryGirl.build(:membership, :phone => nil, :mobile => "0607080910")
      member.should be_valid
      member.save!
    end

    it "mandate_place is mandatory when mandate" do
      member = FactoryGirl.build(:membership, :mandate => "Maire")
      member.should_not be_valid
      member.error_on(:mandate_place).should_not be_empty
    end

    it "mandate_place is captured when mandate" do
      member = FactoryGirl.build(:membership, :mandate => "Maire", :mandate_place => "Paris")
      member.should be_valid
      member.save!
    end

    it "should not be valid with a bad email" do
      member = FactoryGirl.build(:membership, :email => "rien")
      member.should_not be_valid
      member.error_on(:email).should_not be_empty
    end

    it "should not be valid with an amount below the minimum" do
      member = FactoryGirl.build(:membership, :amount => 2.0)
      member.should_not be_valid
      member.error_on(:amount).should_not be_empty
    end
  end

  context "Scopes" do
    it "#predefined_amount returns the amount as a string" do
      member = FactoryGirl.create(:membership, :amount => 36.0)
      member.predefined_amount.should be == "36.0"
    end

    it "#amount_cents returns the amount as cents" do
      member = FactoryGirl.create(:membership, :amount => 36.0)
      member.amount_cents.should be == "3600"
    end

    it "#comites returns a list of committees" do
      3.times {
        article = FactoryGirl.create(:article_departement)
        article.status = Article::ONLINE
        article.save!
      }
      Membership.comites.length.should be == 3
    end

    it "#amounts returns a list of pre-defined amounts" do
      Membership.amounts.length.should be == 6
    end

    it "#responsibilities returns a list of pre-defined responsibilities" do
      Membership.responsibilities.length.should be == 3
    end

    it "#payment_identifier returns a unique identifier" do
      member = FactoryGirl.create(:membership)
      identifier = member.payment_identifier
      identifier.length.should be >= 10
      identifier.should start_with "A"
      identifier.should include("PRENOM")
      identifier.should include("NOM")
    end

    it "#payment_ok? returns true when the payment was validated" do
      member = FactoryGirl.create(:membership_paid)
      member.payment_ok?.should be_true
      member.payment_identifier.should_not be_nil
    end

    it "#payment_ok? returns false when the payment was not validated" do
      member = FactoryGirl.create(:membership_error)
      member.payment_ok?.should be_false
    end

    it "#payment_error_display returns OK when the payment was validated" do
      member = FactoryGirl.create(:membership_paid)
      member.payment_error_display.should be == "OK"
    end

    it "#payment_error_display returns ER when the payment was validated" do
      member = FactoryGirl.create(:membership_error)
      member.payment_error_display.should start_with "ER"
    end

    it "#find_paid returns a list of paid memberships" do
      10.times {
        FactoryGirl.create(:membership_paid)
      }
      Membership.find_paid.length.should be == 10
    end

    it "#find_unpaid returns a list of unpaid memberships" do
      10.times {
        FactoryGirl.create(:membership_error)
      }
      Membership.find_unpaid.length.should be == 10
    end

    it "#to_s returns a description of the membership" do
      member = FactoryGirl.create(:membership)
      identifier = member.to_s
      identifier.should include(member.email)
      identifier.should include("PRENOM")
      identifier.should include("NOM")
      identifier.should include(" NO ")
    end

    it "#header_to_csv returns description of the record in .csv" do
      Membership.header_to_csv.length.should be >= 1
    end

    it "#to_csv returns a description of the membership in .csv" do
      member = FactoryGirl.create(:membership)
      identifier = member.to_csv
      identifier.should include(member.email)
      identifier.should include("Prenom")
      identifier.should include("Nom")
      identifier.should include("PRENOM")
      identifier.should include("NOM")
      identifier.should include("50.0")
    end
  end

  context "Behavior" do
    it "#predefined_amount selects predefined amount from a number" do
      member = FactoryGirl.create(:membership, :predefined_amount => 36.0)
      member.amount.should be == 36.0
    end

    it "#email_notification triggers an email notification" do
      FactoryGirl.create(:user, :notification_membership => true)
      member = FactoryGirl.create(:membership)
      member.email_notification
    end
  end
end