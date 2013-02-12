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

# Controller for donations.
class DonationsController < PaymentController
  caches_action :don, :if => Proc.new { can_cache? }

  # Donation form.
  def don
    @donation = Donation.new
    @don = Article.find_published('don', 1, 1)[0]
  end

  # Control of the donation form and redirects to payment page if it's OK.  
  def valider_don
    saved = false
    begin
      @donation = Donation.new(params[:donation])
      @donation.save!
      saved = true
    rescue ActiveRecord::RecordInvalid => invalid
      log_warning "valider_don", invalid
    end
    if saved
      flash.now[:notice] = t('action.donation.payment')
      @effectue = url_for(:controller => :donations, :action => :don_enregistre)
      @refuse = url_for(:controller => :donations, :action => :don_rejete)
      @retour = url_for(:controller => :donations, :action => :retour_paiement_don)
      @annule = url_for(:controller => :payment, :action => :paiement_annule)
      render :action => :paiement_don
    else
      render :action => :don
    end
  end

  # Donation payment callback.
  def retour_paiement_don
    begin
      @donation = update_payment_record!
      if @donation.present? and @donation.payment_ok?
        @donation.email_notification
      elsif @donation.nil?
        log_error "retour_paiement_don: invalid donation"
      end
    end
    render :nothing => true
  end

  # Payment of the donation is confirmed.
  def don_enregistre
    record = nil
    begin
      record = update_payment_record!
    end
    flash[:notice] = t('action.donation.created') if record.present? and record.payment_ok?
    redirect_to :root
  end

  # Payment of the membership is rejected.  
  def don_rejete
    begin
      update_payment_record!
    end
    flash[:notice] = t('action.donation.error')
    redirect_to :root
  end
end