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
describe MembershipsController do
  render_views

  context "visitors" do
    it "adhesion" do
      article = FactoryGirl.create(:article, :category => 'adhesion')
      article.status = Article::ONLINE
      article.save!
      get :adhesion
      response.should render_template('adhesion')
    end

    it "valider_adhesion with no data" do
      post :valider_adhesion
      response.should render_template('adhesion')
      flash[:notice].should be_nil
    end

    it "valider_adhesion with missing data" do
      post :valider_adhesion, :membership => {
        :department => "Pas-de-Calais (62)",
        :first_name => "Prénom",
        :last_name => "Nom"
      }
      response.should render_template('adhesion')
      flash[:notice].should be_nil
    end

    it "valider_adhesion with bare minimun data" do
      post :valider_adhesion, :membership => {
        :department => "Pas-de-Calais (62)",
        :first_name => "Prénom",
        :last_name => "Nom",
        :gender => "Homme",
        :email => "me@nowhere.com",
        :address => "Avenue de la République",
        :zip_code => "75000",
        :birthdate => "01/12/1960",
        :city => "Paris",
        :phone => "0102030405",
        :predefined_amount => "36.0"
      }
      response.should render_template('paiement_adhesion')
      flash[:notice].should_not be_nil
      expect(assigns(:membership).first_name).to be == "Prénom"
      expect(assigns(:membership).last_name).to be == "Nom"
    end

    it "valider_adhesion with free amount" do
      post :valider_adhesion, :membership => {
        :department => "Pas-de-Calais (62)",
        :first_name => "Prénom",
        :last_name => "Nom",
        :gender => "Homme",
        :email => "me@nowhere.com",
        :address => "Avenue de la République",
        :zip_code => "75000",
        :birthdate => "01/12/1960",
        :city => "Paris",
        :phone => "0102030405",
        :amount => "50"
      }
      response.should render_template('paiement_adhesion')
      flash[:notice].should_not be_nil
      expect(assigns(:membership).first_name).to be == "Prénom"
      expect(assigns(:membership).last_name).to be == "Nom"
    end

    it "valider_adhesion with all the data" do
      post :valider_adhesion, :membership => {
        :renew => "t",
        :department => "Pas-de-Calais (62)",
        :committee => "Lille",
        :first_name => "Prénom",
        :last_name => "Nom",
        :gender => "Homme",
        :email => "me@nowhere.com",
        :address => "Avenue de la République",
        :zip_code => "75000",
        :birthdate => "01/12/1960",
        :city => "Paris",
        :phone => "0102030405",
        :mobile => "0602030405",
        :job => "Peintre",
        :mandate => "Maire",
        :mandate_place => "Lille",
        :union => "AAA",
        :union_resp => "local",
        :assoc => "BBB",
        :assoc_resp => "local",
        :predefined_amount => "36.0",
        :comment => "Long live"
      }
      response.should render_template('paiement_adhesion')
      flash[:notice].should_not be_nil
      expect(assigns(:membership).first_name).to be == "Prénom"
      expect(assigns(:membership).last_name).to be == "Nom"
    end

    it "retour_paiement_adhesion" do
      FactoryGirl.create(:user, :notification_membership => true)
      member = FactoryGirl.create(:membership)
      id = member.id
      get :retour_paiement_adhesion, :erreur => "00000",
                                     :transac => "12345",
                                     :id => member.payment_identifier
      response.should be_success
      member = Membership.where('id = ?', id).first
      member.should_not be_nil
      member.payment_error.should be == "00000"
    end

    it "retour_paiement_adhesion (failure)" do
      FactoryGirl.create(:user, :notification_membership => true)
      member = FactoryGirl.create(:membership)
      id = member.id
      get :retour_paiement_adhesion, :erreur => "00000",
                                     :transac => "12345",
                                     :id => 25
      response.should be_success
      member = Membership.where('id = ?', id).first
      member.should_not be_nil
      member.payment_error.should_not be == "00000"
    end

    it "adhesion_enregistree" do
      member = FactoryGirl.create(:membership)
      id = member.id
      get :adhesion_enregistree, :erreur => "00000",
                                 :transac => "12345",
                                 :id => member.payment_identifier
      response.should redirect_to(root_path)
      flash[:notice].should_not be_nil
      member = Membership.where('id = ?', id).first
      member.should_not be_nil
      member.payment_error.should be == "00000"
    end

    it "adhesion_rejetee" do
      member = FactoryGirl.create(:membership)
      id = member.id
      get :adhesion_rejetee, :erreur => "00099",
                             :transac => "12345",
                             :id => member.payment_identifier
      response.should redirect_to(root_path)
      flash[:notice].should_not be_nil
      member = Membership.where('id = ?', id).first
      member.should_not be_nil
      member.payment_error.should be == "00099"
    end
  end
end