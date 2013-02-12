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

# Controller for memberships.
class MembershipsController < PaymentController
  caches_action :adhesion, :if => Proc.new { can_cache? }

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
      @membership.amount = predefined_amount.to_i if predefined_amount.present? and predefined_amount != "0"
      @membership.save!
      saved = true
    rescue ActiveRecord::RecordInvalid => invalid
      log_warning "valider_adhesion", invalid
    end
    if saved
      flash.now[:notice] = t('action.membership.payment')
      @effectue = url_for(:controller => :memberships, :action => :adhesion_enregistree)
      @refuse = url_for(:controller => :memberships, :action => :adhesion_rejetee)
      @retour = url_for(:controller => :memberships, :action => :retour_paiement_adhesion)
      @annule = url_for(:controller => :payment, :action => :paiement_annule)
      render :action => :paiement_adhesion
    else
      render :action => :adhesion
    end
  end

  # Membership payment callback.
  def retour_paiement_adhesion
    begin
      @membership = update_payment_record!
      if @membership.present? and @membership.payment_ok?
        @membership.email_notification
      elsif @membership.nil?
        log_error "retour_paiement_adhesion: invalid membership"
      end
    end
    render :nothing => true
  end

  # Payment of the membership is confirmed.
  def adhesion_enregistree
    record = nil
    begin
      record = update_payment_record!
    end
    flash[:notice] = t('action.membership.created') if record.present? and record.payment_ok?
    redirect_to :root
  end

  # Payment of the membership is rejected.  
  def adhesion_rejetee
    begin    
      update_payment_record!
    end
    flash[:notice] = t('action.membership.error')
    redirect_to :root
  end
end