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
  class Watermark < Processor

    attr_accessor :format, :watermark_path, :position
    
    def initialize file, options = {}, attachment = nil
       super
       @file             = file
       @basename         = File.basename(@file.path, File.extname(@file.path))
       @format           = options[:format]
       @watermark_path   = options[:watermark_path]
       @position         = options[:position].nil? ? "SouthWest" : options[:position]
     end
     
    def make
      dest = Tempfile.new([@basename, @format].compact.join("."))
      dest.binmode
      if watermark_path
        command = "composite"
        params = "-gravity #{@position} #{watermark_path} #{fromfile} #{tofile(dest)}"
      else
        command = "convert"
        params = "#{fromfile} #{tofile(dest)}"
      end
      Paperclip.run(command, params)
      dest
    end

    def fromfile; "\"#{ File.expand_path(@file.path) }[0]\"" end
    def tofile(destination) ; "\"#{ File.expand_path(destination.path) }[0]\"" end
  end
end