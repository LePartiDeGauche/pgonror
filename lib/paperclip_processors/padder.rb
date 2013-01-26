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
module Paperclip
  class Padder < Thumbnail
    def initialize(file, options = {}, attachment = nil)
      super
      @gravity = options[:gravity].nil? ? "Center" : options[:gravity]
    end

    def transformation_command
      scale, crop = @current_geometry.transformation_to(@target_geometry, crop?)
      trans = []
      trans << "-resize" << %["#{scale}"] unless scale.nil? or scale.empty?
      if @current_geometry.width.to_i > @current_geometry.height.to_i
        if crop?
          crop = "#{@target_geometry.width.to_i}x#{@target_geometry.height.to_i}+0+0"
          trans << "-gravity #{@gravity} -crop" << %["#{crop}"] << "+repage"
        end
      else
        trans << "-gravity Center"
      end
      trans << "-strip" << "-background white" << "-extent" << %["#{geometry_extent}"]
      trans
    end

    def geometry_extent
      target_geometry.height.to_i > 0 ?
        "#{target_geometry.width.to_i}x#{target_geometry.height.to_i}" :
        "#{target_geometry.width.to_i}"
    end
  end
end