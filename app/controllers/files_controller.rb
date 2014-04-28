class FilesController < ApplicationController
  def initialize
    @base_path = "#{Rails.root}/public/system/"
  end

  # provides the download after building the arguments (path, mimetype and filename) from get request 
  def download
    send_file File.join(@base_path, params[:type], params[:name])
  end
end
