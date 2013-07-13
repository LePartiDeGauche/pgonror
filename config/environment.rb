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

# Load the rails application.
require File.expand_path('../application', __FILE__)
require File.expand_path('../menus', __FILE__)
require File.expand_path('../categories', __FILE__)

# Forces encoding.
Encoding.default_external = Encoding::UTF_8
Encoding.default_internal = Encoding::UTF_8

# Initializes the rails application.
PartiDeGauche::Application.initialize!

# Turns off auto TLS for e-mail.
ActionMailer::Base.smtp_settings[:enable_starttls_auto] = false