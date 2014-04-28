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

# Defines users who can access protected information, enter enter web content or administer the system.
# User authentification is managed with Devise https://github.com/plataformatec/devise.
class User < ActiveRecord::Base

  # Defines access level for visitors.
  ACCESS_LEVELS = [
    ["Public", 'public'],
    ["Adhérent", 'reserved']
  ]

  validates :email, :uniqueness => true, :length => {:minimum => 3, :maximum => 50}, :email => true

  has_many :permissions,-> { order('source_id, category') }, :class_name => 'Permission',  :foreign_key => :user_id, :dependent => :destroy

  devise :database_authenticatable, 
         :registerable,
         :recoverable,
         :confirmable, 
         :rememberable, 
         :trackable, 
         :validatable,
         :lockable

  after_create :notification_new_user

  # List (array) of access levels used in lists of values.
  def self.access_levels
    ACCESS_LEVELS
  end

  # Returns the access level of the user.  
  def access_level_display
    return "" if self.access_level.blank?
    ACCESS_LEVELS.find {|meaning, code| self.access_level == code}[0]
  end
  
  # Prepare SQL string against SQL injection.
  def self.quote(string)
    '\'' + string.gsub(/\\/, '\&\&').gsub(/'/, "''") + '\''
  end

  # Returns users who match email address.
  def self.find_like_email(email)
    User.where("lower(email) like #{quote('%' + email.downcase.strip + '%')}").order('last_sign_in_at desc')
  end

  # Returns the authorization of given user, category and source of information.
  def self.get_authorization_article(user_email, category, source_id = nil)
    user = User.where("email = ? and publisher = ?", user_email, true).first
    return nil if user.nil?
    permission = user.permissions.where("(category is null or category = '' or category = ?) and (source_id is null or source_id = ?)", category, source_id).first
    return permission.present? ? permission.authorization : nil
  end

  # Returns an array of users who've got a specific permission set to true.  
  def self.notification_recipients(notification)
    recipients = []
    for user in User.where("#{notification} = ?", true)
      recipients << user.email
    end
    recipients
  end

  # Triggers a notification when a new user has been created.  
  def notification_new_user
    recipients = User.notification_recipients("notification_alert")
    Notification.notification_new_user(Devise.mailer_sender,
                                       recipients,
                                       I18n.t('mailer.notification_new_user'),
                                       self.email).deliver unless recipients.empty?
  end
end