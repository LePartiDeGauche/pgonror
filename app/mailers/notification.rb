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

# Email notifications.
class Notification < ActionMailer::Base
  include ActionView::Helpers::NumberHelper

  def phone_format(phone)
    phone.nil? ? "" : phone.gsub(/\D/, "").gsub(/(\d{2,})(\d{2})(\d{2})(\d{2})(\d{2})/, "\\1 \\2 \\3 \\4 \\5")
  end

  # Notifies a new user has been created.
  def notification_new_user(from, recipients, subject, email)
    @email = email
    mail(:from => from, :to => recipients, :subject => subject)
  end  

  # Notifies an article is created or updated.
  def notification_update(from, 
                          recipients, 
                          subject, 
                          heading,
                          title,
                          category,
                          source,
                          folder, 
                          status, 
                          signature, 
                          url,
                          published_url,
                          tags,
                          content,
                          image_url, 
                          published_at,
                          expired_at,
                          zoom,
                          created_by,
                          comments)
    @heading = heading
    @title = title
    @category = category
    @source = source
    @folder = folder
    @status = status
    @signature = signature
    @url = url
    @published_url = published_url
    @tags = tags
    @content = content
    @image_url = image_url
    @published_at = published_at.nil? ? nil : I18n.l(published_at, :format => :long_ordinal)
    @expired_at = expired_at.nil? ? nil : I18n.l(expired_at, :format => :long_ordinal)
    @zoom = zoom
    @created_by = created_by
    @updated_by = from
    @comments = comments
    cc = []
    cc << created_by if not recipients.include?(created_by) and created_by =~ /(.*)@(.*)/
    mail(:from => from, :to => recipients, :cc => cc, :subject => subject.to_s + " " + category + " - " + status + " : " + title)
  end  

  # Notifies a new message has been entered.
  def notification_message(from, 
                           recipients, 
                           subject, 
                           first_name,
                           last_name, 
                           email, 
                           address, 
                           zip_code,
                           city, 
                           phone,
                           comment)
    @first_name = first_name
    @last_name = last_name
    @email = email
    @address = address
    @zip_code = zip_code
    @city = city
    @phone = phone_format phone
    @comment = comment
    mail(:from => from, :to => recipients, :subject => subject)
  end  

  # Notifies new subscription.
  def notification_subscription(from, 
                                recipients, 
                                subject, 
                                first_name,
                                last_name, 
                                email, 
                                address, 
                                zip_code,
                                city, 
                                phone)
    @first_name = first_name
    @last_name = last_name
    @email = email
    @address = address
    @zip_code = zip_code
    @city = city
    @phone = phone_format phone
    mail(:from => from, :to => recipients, :subject => subject)
  end  

  # Notifies new membership.
  def notification_membership(from, 
                              recipients, 
                              subject, 
                              first_name,
                              last_name, 
                              gender,
                              email, 
                              address, 
                              zip_code,
                              city, 
                              phone,
                              mobile,
                              renew,
                              department,
                              committee,
                              birthdate,
                              job,
                              mandate,
                              union,
                              union_resp,
                              assoc,
                              assoc_resp,
                              mandate_place,
                              comment,
                              amount,
                              payment_identifier)
    @first_name = first_name
    @last_name = last_name
    @gender = gender
    @email = email
    @address = address
    @zip_code = zip_code
    @city = city
    @phone = phone_format phone
    @mobile = phone_format mobile
    @renew = renew
    @department = department
    @committee = committee
    @birthdate = birthdate.strftime("%d/%m/%Y")
    @job = job
    @mandate = mandate
    @union = union
    @union_resp = union_resp
    @assoc = assoc
    @assoc_resp = assoc_resp
    @mandate_place = mandate_place
    @comment = comment
    @amount = number_to_currency(amount)
    @payment_identifier = payment_identifier
    mail(:from => from, 
         :to => recipients, 
         :subject => subject + " " + payment_identifier)
  end  

  # Notifies new donation.
  def notification_donation(from, 
                           recipients, 
                           subject, 
                           first_name,
                           last_name, 
                           email, 
                           address, 
                           zip_code,
                           city, 
                           phone,
                           comment,
                           amount,
                           payment_identifier)
    @first_name = first_name
    @last_name = last_name
    @email = email
    @address = address
    @zip_code = zip_code
    @city = city
    @phone = phone_format phone
    @comment = comment
    @amount = number_to_currency(amount)
    @payment_identifier = payment_identifier
    mail(:from => from, 
         :to => recipients, 
         :subject => subject + " " + payment_identifier)
  end  

  # Notifies a administrators or an alert.
  def alert_admins(from, 
                   recipients, 
                   subject, 
                   message,
                   request, 
                   params,
                   invalid_backtrace)
    @message = message
    @request = request
    @params = params
    @invalid_backtrace = invalid_backtrace
    mail(:from => from, :to => recipients, :subject => subject.to_s)
  end  
end