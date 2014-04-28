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
  class Ogg < Processor
    attr_accessor :extension

    def initialize(file, options = {}, attachment = nil)
      super
      @file = file
      @attachment = attachment
      @filename = File.basename(@attachment.instance.audio_file_name, File.extname(@attachment.instance.audio_file_name))
      @extension = options[:extension]
      @audio_path = @attachment.instance.category_option(:storage)
    end

    def make
      target = File.join(File.dirname(@attachment.path), @audio_path, (@filename + @extension))
      FileUtils.mkdir_p(File.dirname(@attachment.path))
      Paperclip.run('avconv', "-y -i #{File.expand_path(@file.path)} -acodec libvorbis #{target}")
      dst = File.open @file.path
    end
  end
end
