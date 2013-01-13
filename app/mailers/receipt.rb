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
class Receipt < ActionMailer::Base
  def receipt_message(from, 
                      recipient, 
                      subject, 
                      first_name,
                      last_name)
    @first_name = first_name
    @last_name = last_name
    mail(:from => from, :to => recipient, :subject => subject)
  end  

  def receipt_subscription(from, 
                           recipient, 
                           subject, 
                           first_name,
                           last_name)
    @first_name = first_name
    @last_name = last_name
    mail(:from => from, :to => recipient, :subject => subject)
  end  

  def receipt_membership(from, 
                         recipient, 
                           subject, 
                         first_name,
                         last_name)
    @first_name = first_name
    @last_name = last_name
    mail(:from => from, :to => recipient, :subject => subject)
  end  

  def receipt_donation(from, 
                       recipient, 
                       subject, 
                       first_name,
                       last_name)
    @first_name = first_name
    @last_name = last_name
    mail(:from => from, :to => recipient, :subject => subject)
  end  
end