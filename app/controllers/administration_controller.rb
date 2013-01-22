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
class AdministrationController < ApplicationController
  before_filter :authenticate_user!
  before_filter :authenticate_administrator!
  
  def index
    @type = params[:type]
    logs = case @type
    when 'donations'
      @label = t('action.donation.log')
      Donation.logs
    when 'dons_payes'
      @label = t('action.donation.paid_log')
      Donation.paid_logs
    when 'dons_nonaboutis'
      @label = t('action.donation.unpaid_log')
      Donation.unpaid_logs
    when 'ml_subscribers'
      @label = t('action.subscription.log')
      Subscription.logs
    when 'adherents'
      @label = t('action.membership.log')
      Membership.logs
    when 'adherents_paye'
      @label = t('action.membership.paid_log')
      Membership.paid_logs
    when 'adherents_nonabouti'
      @label = t('action.membership.unpaid_log')
      Membership.unpaid_logs
    when 'messages'
      @label = t('action.request.log')
      Request.logs
    when 'audits'
      @label = t('action.audit.log')
      Audit.logs
    end
    unless logs.nil?
      logs = logs.filtered_by(@search) if @search
      @logs = logs.empty? ? logs : logs.page(@page)
    else
      @label = t('general.administration')
      @logs = []
    end
  end
end