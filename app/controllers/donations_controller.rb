# encoding: utf-8
# PGonror is the corporate web site framework of Le Parti de Gauche based on Ruby on Rails.
# 
# Copyright (C) 2012 Le Parti de Gauche
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
      saved = false
    rescue Exception => invalid
      log_error "valider_don", invalid
      saved = false
    end
    respond_to do |format|
      if saved
        flash.now[:notice] = t('action.donation.payment')
        @effectue = url_for(:controller => :donations, :action => :don_enregistre)
        @refuse = url_for(:controller => :donations, :action => :don_rejete)
        @retour = url_for(:controller => :donations, :action => :retour_paiement_don)
        @annule = url_for(:controller => :payment, :action => :paiement_annule)
        format.html { render :action => :paiement_don }
      else
        format.html { render :action => :don }
      end
    end
  end
  
  # Payment form for donation.
  def paiement_don
  end
  
  # Donation payment callback.
  def retour_paiement_don
    begin
      @donation = update_payment_record!
      if @donation.present? and @donation.payment_ok?
        recipients = User.notification_recipients "notification_donation"
        if not recipients.empty?
          Notification.notification_donation(@donation.email, 
                                             recipients.join(', '),
                                             t('mailer.notification_donation_subject'),
                                             @donation.first_name,
                                             @donation.last_name, 
                                             @donation.email, 
                                             @donation.address, 
                                             @donation.zip_code,
                                             @donation.city, 
                                             @donation.phone,
                                             @donation.comment,
                                             @donation.amount,
                                             @donation.payment_identifier).deliver
        end
        Receipt.receipt_donation(Devise.mailer_sender, 
                                 @donation.email,
                                 t('mailer.receipt_donation_subject'),
                                 @donation.first_name,
                                 @donation.last_name,
                                 url_for(:controller => :accueil,
                                        :action => :index,
                                        :only_path => false)).deliver
      elsif @donation.nil?
        log_error "retour_paiement_don: invalid donation"
      end
    rescue Exception => invalid
      log_error "retour_paiement_don", invalid
    end
    render :nothing => true
  end

  # Payment of the donation is confirmed.
  def don_enregistre
    record = nil
    begin
      record = update_payment_record!
    rescue Exception => invalid
      log_error "don_enregistre", invalid
    end
    flash[:notice] = t('action.donation.created') if record.present? and record.payment_ok?
    redirect_to :root
  end
  
  # Payment of the membership is rejected.  
  def don_rejete
    begin
      update_payment_record!
    rescue Exception => invalid
      log_error "don_rejete", invalid
    end
    flash[:notice] = t('action.donation.error')
    redirect_to :root
  end
end