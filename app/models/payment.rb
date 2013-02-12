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

# Defines an abstract class used to define payment functionalities.
class Payment < ActiveRecord::Base
  self.abstract_class = true

  validates :amount, :presence => true, :numericality => true

  # Setup accessible (or protected) attributes for the model.
  attr_accessible :amount,
                  :payment_error,
                  :payment_authorization

  # Returns the amount in cents as a string.  
  def amount_cents
    (100*self.amount.to_i).to_s
  end

  # Returns true if the payment is OK.  
  def payment_ok?
    self.payment_error.nil? ? false : self.payment_error == "00000"
  end

  # Returns the paybox information in a display mode.  
  def payment_error_display
    return "NO" if self.payment_error.blank?
    return "OK" if self.payment_error == "00000"
    "ER:" + self.payment_error
  end

  # Prepares a string for .csv export.
  def escape_csv(text)
    text.nil? ? "" : text.strip.gsub(/(;|\n|\r|\|’")/, " ")
  end

protected

  # Returns a clean identifier given as parameter. 
  def clean_identifier(identifier)
    identifier.
        gsub(/[àâä]/,"a").
        gsub(/[ÀÂÄ]/,"A").
        gsub(/[éèêë]/,"e").
        gsub(/[ÉÈÊË]/,"E").
        gsub(/[ìîï]/,"i").
        gsub(/[ÌÎÏ]/,"I").
        gsub(/[òôö]/,"o").
        gsub(/[ÒÔÖ]/,"O").
        gsub(/[ùûü]/,"u").
        gsub(/[ÙÛÜ]/,"U").
        gsub(/[ç]/,"c").
        gsub(/[Ç]/,"C").
        gsub(/[œ]/,"oe").
        gsub(/[Œ]/,"OE").
        gsub(/[^a-zA-Z0-9\-\ ]/,"")
  end
end