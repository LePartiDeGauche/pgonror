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
describe PaymentController do
  render_views

  context "visitors" do
    it "paiement_annule" do
      donation = FactoryGirl.create(:donation)
      id = donation.id
      get :paiement_annule, :erreur => "00001",
                            :transac => "0",
                            :id => donation.payment_identifier
      flash[:notice].should_not be_nil
      response.should redirect_to(root_path)
      donation = Donation.where('id = ?', id).first
      donation.should_not be_nil
      donation.payment_error.should be == "00001"
    end
  end
end