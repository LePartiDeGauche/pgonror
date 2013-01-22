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

# Controller for payments (abstract) used for memberships and donations.
class PaymentController < ApplicationController
  # Payment cancellation.
  def paiement_annule
    begin
      update_payment_record!
    end
    flash[:notice] = t('action.payment.cancelled')
    redirect_to :root
  end

protected  
  
  # Regular expression used to identify payment references
  PAYMENT_REF = /(A|R|D)(\d*) (.*)/
  
  # Updates a payment record (membership or donation) based on payment identifier.
  def update_payment_record!
    error = params[:erreur]
    payment_reference = params[:id]
    authorization = params[:numauto]
    record = nil
    if payment_reference.present? and payment_reference =~ PAYMENT_REF
      payment = payment_reference.scan PAYMENT_REF
      type = payment[0][0] 
      id = payment[0][1].to_i
      if "A" == type.upcase or "R" == type.upcase 
        record = Membership::find_by_id id
      elsif "D" == type.upcase
        record = Donation::find_by_id id
      end
      if record.present?
        record.transaction do
          record.payment_error = error
          record.payment_authorization = authorization
          record.save!
        end
      end        
    end
    record
  end
end