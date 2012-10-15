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

# Defines online donations to the association.
# All the information entered by users in the form are stored in system,
# but the payment of the donation  is managed externally.
# Only references to the payment is tracked in the system.
class Donation < Payment
  include ActionView::Helpers::NumberHelper
  
  validates :first_name, :length => {:minimum => 3, :maximum => 30}
  validates :last_name, :length => {:minimum => 3, :maximum => 30}
  validates :address, :presence => true, :length => {:maximum => 80}
  validates :zip_code, :presence => true, :length => {:maximum => 10}
  validates :city, :presence => true, :length => {:maximum => 80}
  validates :phone, :length => {:maximum => 30}
  validates :email, :length => {:minimum => 3, :maximum => 50}, :email => true
  validate :amount_range_mini
  validate :amount_range
  validates :comment, :length => {:maximum => 1000}
  
  # Setup accessible (or protected) attributes for the model.
  attr_accessible :last_name,
                  :first_name,
                  :email,
                  :address,
                  :zip_code,
                  :city,
                  :phone,
                  :comment

  # Defines the minimum amount for a donation.  
  MIN_AMOUNT = 10.0

  # Defines the maximum amount for a donation.  
  MAX_AMOUNT = 7500.0
  
  # Valides the amount is entered and is greater or equal to the minimum.  
  def amount_range_mini
    if self.amount.present? and self.amount < MIN_AMOUNT
      errors.add(:amount, I18n.t('activerecord.attributes.membership.amount_error', :min => number_to_currency(MIN_AMOUNT)))
    end
  end
  
  # Valides the amount is entered and is less than the maximum.  
  def amount_range
    if self.amount.present? and self.amount > MAX_AMOUNT
      errors.add(:amount, I18n.t('activerecord.attributes.donation.amount_error', :max => number_to_currency(MAX_AMOUNT)))
    end
  end
  
  # Returns a unique identifier used for payment identification.
  def payment_identifier
    clean_identifier("D" + self.id.to_s + " " + self.last_name.strip + " " + self.first_name.strip)
  end
  
  # For logs in Administration panel
  paginates_per 100
  scope :logs, order('created_at DESC')
  scope :filtered_by, lambda { |search| where('lower(first_name) LIKE ? OR lower(last_name) LIKE ? OR lower(email) LIKE ?', "%#{search.downcase.strip}%", "%#{search.downcase.strip}%", "%#{search.downcase.strip}%") }
  
  # Returns the content as a string used for display.  
  def to_s
    "#{I18n.l(created_at)} : #{payment_identifier} (#{email}) #{number_to_currency(amount)} - #{payment_error_display} #{payment_authorization}"
  end
end