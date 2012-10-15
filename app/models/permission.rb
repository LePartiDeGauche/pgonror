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

# Defines permissions of users to enter and publish web content (articles).
class Permission < ActiveRecord::Base
  belongs_to :user, 
             :class_name => 'User', 
             :foreign_key => :user_id

  belongs_to :source, 
             :class_name => 'Article', 
             :foreign_key => :source_id

  # Basic controls.
  validates_presence_of :category, :authorization, :updated_by

  # Setup accessible (or protected) attributes for the model.
  attr_accessible :user_id,
                  :source_id,
                  :category,
                  :authorization,
                  :notification_level

  # Managed authorizations.
  EDITOR = 'editor'
  REVIEWER = 'reviewer'
  PUBLISHER = 'publisher'

  # List of managed authorizations.
  AUTHORIZATIONS = {
   EDITOR => I18n.t('permission.authorization.editor'),
   REVIEWER => I18n.t('permission.authorization.reviewer'),
   PUBLISHER => I18n.t('permission.authorization.publisher')
  }

  # List (array) of authorizations used in lists of values.
  def self.authorizations
   [[I18n.t('permission.authorization.editor'), EDITOR],
    [I18n.t('permission.authorization.reviewer'), REVIEWER],
    [I18n.t('permission.authorization.publisher'), PUBLISHER]
   ]
  end
  
  # Returns the authorization of the permission.  
  def self.authorization_display(authorization)
    AUTHORIZATIONS.find {|code, meaning| authorization == code}[1] 
  end
  
  # Returns the authorization of the permission.  
  def authorization_display
    Permission::authorization_display self.authorization
  end
  
  # List (array) of authorizations used in lists of values.
  def self.notifications
   [[I18n.t('article.status.new'), Article::NEW],
    [I18n.t('article.status.reviewed'), Article::REVIEWED]
   ]
  end
  
  # Returns the notification of the permission.  
  def notification_level_display
    if self.notification_level == Article::NEW
      I18n.t('article.status.new')
    elsif self.notification_level == Article::REVIEWED
      I18n.t('article.status.reviewed')
    else
      "-"
    end
  end
  
  # Returns the title of the source of information the permission is defined for.  
  def source_display
   self.source_id.present? ? self.source.to_s : "-"
  end
  
  # Returns the title of the permission category.  
  def category_display
   category = get_category_definition
   category.present? ? category[0] : "-"
  end
  
  # Returns the list of recipients for notification
  def self.notification_recipients(status, category, source_id = nil)
    recipients = []
    permissions = Permission.where("(category is null or category = '' or category = ?) and (source_id is null or source_id = ?) and notification_level is not null and notification_level != ''", category, source_id)
    for permission in permissions
      include = false
      if permission.notification_level == Article::NEW
        include = true
      elsif permission.notification_level == Article::REVIEWED
        include = (status == Article::REVIEWED) or (status == Article::ONLINE) 
      end
      if include
        user = User.where("id = ? and publisher = ?", permission.user_id, true).first
        if user.present?
          recipients << user.email
        end
      end
    end
    recipients
  end
  
private

  # Returns the definition (title, code and options) of the permission category.
  def get_category_definition
   CATEGORIES.find {|meaning, code| (self.category.nil? ? NEW : self.category) == code}
  end

  # Returns the definition (title, code and options) of one permission category.
  def self.get_category_definition(category)
   CATEGORIES.find {|meaning, code| category == code}
  end
end