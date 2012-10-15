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
module Paperclip
  class Padder < Thumbnail
    def transformation_command
      super + ["-strip",
               "-gravity center",
               "-background white",
               "-extent", %["#{geometry_extent}"]]
    end

    def geometry_extent
      target_geometry.height.to_i > 0 ? 
        "#{target_geometry.width.to_i}x#{target_geometry.height.to_i}" : 
        "#{target_geometry.width.to_i}"
    end
  end
end