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

# Defines requests (messages) the users can enter in the web site.
class Request < ActiveRecord::Base
  validates :recipient, :presence => true
  validates :first_name, :length => {:minimum => 3, :maximum => 30}, :presence => true
  validates :last_name, :length => {:minimum => 3, :maximum => 30}, :presence => true
  validates :address, :length => {:maximum => 80}
  validates :zip_code, :length => {:maximum => 10}
  validates :city, :length => {:maximum => 80}
  validates :phone, :length => {:maximum => 30}
  validates :comment, :presence => true, :length => {:minimum => 50, :maximum => 1000}
  validates :email, :length => {:minimum => 3, :maximum => 50}, :email => true, :presence => true
  
  # Returns the name of the recipient using the article uri
  def recipient_display
    return "" if self.recipient.nil?
    recipient = Article::find_by_uri self.recipient
    recipient.present? ? ("[" + recipient.title + "] ") : ""
  end 
  
  # Returns the content as a string used for display.  
  def to_s
    "#{I18n.l(created_at)} : #{first_name} #{last_name} (#{email}) #{recipient_display}#{comment}"
  end

  # Triggers an email notification for a new request.
  def email_notification
    recipients = nil
    if self.recipient.present?
      recipient = Article::find_by_uri(self.recipient)
      if recipient.present? and recipient.email.present?
        recipients = [recipient.email]
      end
    end
    recipients = User.notification_recipients("notification_message") if recipients.nil?
    if not recipients.empty?
      Notification.notification_message(self.email,
                                        recipients.join(', '),
                                        I18n.t('mailer.notification_message_subject'),
                                        self.first_name,
                                        self.last_name,
                                        self.email,
                                        self.address,
                                        self.zip_code,
                                        self.city,
                                        self.country,
                                        self.phone,
                                        self.comment).deliver
    end
    Receipt.receipt_message(Devise.mailer_sender,
                            self.email,
                            I18n.t('mailer.receipt_message_subject'),
                            self.first_name,
                            self.last_name).deliver
  end

  # Formats phone number.
  def phone_format(phone)
    phone.nil? ? "" : phone.gsub(/\D/, "").gsub(/(\d{2,})(\d{2})(\d{2})(\d{2})(\d{2})/, "\\1 \\2 \\3 \\4 \\5")
  end

  # Returns the header of a file used for export (csv format).  
  def self.header_to_csv
    "Nom;" +
    "Prenom;" +
    "Adresse;" +
    "CodePostal;" +
    "Ville;" +
    "Pays;" +
    "Telephone;" +
    "Email;" +
    "Commentaire"
  end

  # Returns the content as a string used for export (csv format).  
  def to_csv
    "#{clean_identifier last_name};" +
    "#{clean_identifier first_name};" +
    "#{escape_csv address};" +
    "#{escape_csv zip_code};" +
    "#{escape_csv city};" +
    "#{escape_csv country};" +
    "#{phone_format phone};" +
    "#{escape_csv email};" +
    "#{escape_csv comment}"
  end

  # For logs in Administration panel
  scope :logs, -> { order('created_at DESC') }
  scope :filtered_by, lambda { |search| where('lower(first_name) LIKE ? OR lower(last_name) LIKE ? OR lower(email) LIKE ? OR lower(comment) LIKE ?', "%#{search.downcase.strip}%", "%#{search.downcase.strip}%", "%#{search.downcase.strip}%", "%#{search.downcase.strip}%") }

protected

  # Prepares a string for .csv export.
  def escape_csv(text)
    text.nil? ? "" : text.strip.gsub(/(;|\n|\r|\|’")/, " ")
  end

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