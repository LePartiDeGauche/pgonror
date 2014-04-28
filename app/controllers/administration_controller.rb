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
  before_action :authenticate_user!
  before_action :authenticate_administrator!

  def index
    @type = params[:type]
    logs = case @type
    when 'donations'
      Donation.logs
    when 'dons_payes'
      Donation.paid_logs
    when 'dons_nonaboutis'
      Donation.unpaid_logs
    when 'ml_subscribers'
      Subscription.logs
    when 'adherents'
      Membership.logs
    when 'adherents_paye'
      Membership.paid_logs
    when 'adherents_nonabouti'
      Membership.unpaid_logs
    when 'messages'
      Request.logs
    when 'audits'
      Audit.logs
    end
    unless logs.nil?
      @logs = logs
      @logs = logs.filtered_by(@search) if @search
    else
      @logs = []
    end
  end
end