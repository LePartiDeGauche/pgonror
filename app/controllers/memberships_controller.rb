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

# Controller for memberships.
class MembershipsController < PaymentController
  # Membership form.
  def adhesion
    @membership = Membership.new
    @adhesion = Article.find_published('adhesion', 1, 1)[0]
  end

  # Control of the membership form and redirects to payment page if it's OK.  
  def valider_adhesion
    saved = false
    begin
      @membership = Membership.new(params[:membership])
      @membership.renew = params[:renew]
      predefined_amount = params[:membership][:predefined_amount] if params[:membership].present?
      @membership.amount = predefined_amount.to_i if predefined_amount != "0"
      @membership.save!
      saved = true
    rescue ActiveRecord::RecordInvalid => invalid
      log_warning "valider_adhesion", invalid
      saved = false
    rescue Exception => invalid
      log_error "valider_adhesion", invalid
      saved = false
    end
    respond_to do |format|
      if saved
        flash.now[:notice] = t('action.membership.payment')
        @effectue = url_for(:controller => :memberships, :action => :adhesion_enregistree)
        @refuse = url_for(:controller => :memberships, :action => :adhesion_rejetee)
        @retour = url_for(:controller => :memberships, :action => :retour_paiement_adhesion)
        @annule = url_for(:controller => :payment, :action => :paiement_annule)
        format.html { render :action => :paiement_adhesion }
      else
        format.html { render :action => :adhesion }
      end
    end
  end
  
  # Payment form for membership.
  def paiement_adhesion
  end
  
  # Membership payment callback.
  def retour_paiement_adhesion
    begin
      @membership = update_payment_record!
      if @membership.present? and @membership.payment_ok?
        recipients = User.notification_recipients "notification_membership"
        if not recipients.empty?
          Notification.notification_membership(@membership.email, 
                                               recipients.join(', '),
                                               t(@membership.renew ? 
                                                        'mailer.notification_membership_subject_renew' :
                                                        'mailer.notification_membership_subject'),
                                               @membership.first_name,
                                               @membership.last_name, 
                                               @membership.gender,
                                               @membership.email, 
                                               @membership.address, 
                                               @membership.zip_code,
                                               @membership.city, 
                                               @membership.phone,
                                               @membership.mobile,
                                               @membership.renew,
                                               @membership.department,
                                               @membership.committee,
                                               @membership.birthdate,
                                               @membership.job,
                                               @membership.mandate,
                                               @membership.union,
                                               @membership.union_resp,
                                               @membership.assoc,
                                               @membership.assoc_resp,
                                               @membership.mandate_place,
                                               @membership.comment,
                                               @membership.amount,
                                               @membership.payment_identifier).deliver
        end
        Receipt.receipt_membership(Devise.mailer_sender, 
                                   @membership.email,
                                   t('mailer.receipt_membership_subject'),
                                   @membership.first_name,
                                   @membership.last_name,
                                   url_for(:controller => :accueil,
                                        :action => :index,
                                        :only_path => false)).deliver
      elsif @membership.nil?
        log_error "retour_paiement_adhesion: invalid membership"
      end
    rescue Exception => invalid
      log_error "retour_paiement_adhesion", invalid
    end
    render :nothing => true
  end

  # Payment of the membership is confirmed.
  def adhesion_enregistree
    record = nil
    begin
      record = update_payment_record!
    rescue Exception => invalid
      log_error "adhesion_enregistree", invalid
    end
    flash[:notice] = t('action.membership.created') if record.present? and record.payment_ok?
    redirect_to :root
  end

  # Payment of the membership is rejected.  
  def adhesion_rejetee
    begin    
      update_payment_record!
    rescue Exception => invalid
      log_error "adhesion_rejetee", invalid
    end
    flash[:notice] = t('action.membership.error')
    redirect_to :root
  end
end