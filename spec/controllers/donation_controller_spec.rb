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
describe DonationsController do
  render_views

  context "visitors" do
    it "don" do
      article = FactoryGirl.create(:article, :category => 'don')
      article.status = Article::ONLINE
      article.save!
      get :don
      response.should render_template('don')
    end

    it "valider_don with no data" do
      post :valider_don
      response.should render_template('don')
      flash[:notice].should be_nil
    end

    it "valider_don with missing data" do
      post :valider_don, :donation => {
        :first_name => "Prénom",
        :last_name => "Nom"
      }
      response.should render_template('don')
      flash[:notice].should be_nil
    end

    it "valider_don with bare minimun data" do
      post :valider_don, :donation => {
        :first_name => "Prénom",
        :last_name => "Nom",
        :email => "me@nowhere.com",
        :address => "Avenue de la République",
        :zip_code => "75000",
        :city => "Paris",
        :amount => "100"
      }
      response.should render_template('paiement_don')
      flash[:notice].should_not be_nil
      expect(assigns(:donation).first_name).to be == "Prénom"
      expect(assigns(:donation).last_name).to be == "Nom"
    end

    it "valider_don with all the data" do
      post :valider_don, :donation => {
        :first_name => "Prénom",
        :last_name => "Nom",
        :email => "me@nowhere.com",
        :address => "Avenue de la République",
        :zip_code => "75000",
        :city => "Paris",
        :phone => "0102030405",
        :amount => "150",
        :comment => "Long live"
      }
      response.should render_template('paiement_don')
      flash[:notice].should_not be_nil
      expect(assigns(:donation).first_name).to be == "Prénom"
      expect(assigns(:donation).last_name).to be == "Nom"
    end

    it "retour_paiement_don" do
      FactoryGirl.create(:user, :notification_donation => true)
      donation = FactoryGirl.create(:donation)
      id = donation.id
      get :retour_paiement_don, :erreur => "00000",
                                :transac => "12345",
                                :id => donation.payment_identifier
      response.should be_success
      donation = Donation.where('id = ?', id).first
      donation.should_not be_nil
      donation.payment_error.should be == "00000"
    end

    it "retour_paiement_don (failure)" do
      FactoryGirl.create(:user, :notification_donation => true)
      donation = FactoryGirl.create(:donation)
      id = donation.id
      get :retour_paiement_don, :erreur => "00000",
                                :transac => "12345",
                                :id => 26
      response.should be_success
      donation = Donation.where('id = ?', id).first
      donation.should_not be_nil
      donation.payment_error.should_not be == "00000"
    end

    it "don_enregistre" do
      donation = FactoryGirl.create(:donation)
      id = donation.id
      get :don_enregistre, :erreur => "00000",
                           :transac => "12345",
                           :id => donation.payment_identifier
      response.should redirect_to(root_path)
      flash[:notice].should_not be_nil
      donation = Donation.where('id = ?', id).first
      donation.should_not be_nil
      donation.payment_error.should be == "00000"
    end

    it "don_rejete" do
      donation = FactoryGirl.create(:donation)
      id = donation.id
      get :don_rejete, :erreur => "00099",
                       :transac => "12345",
                       :id => donation.payment_identifier
      response.should redirect_to(root_path)
      flash[:notice].should_not be_nil
      donation = Donation.where('id = ?', id).first
      donation.should_not be_nil
      donation.payment_error.should be == "00099"
    end
  end
end