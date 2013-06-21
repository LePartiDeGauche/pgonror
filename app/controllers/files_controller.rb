class FilesController < ApplicationController
  def initialize
    @base_path = "#{Rails.root}/public/system/"
  end

  # provides the download after building the arguments (path, mimetype and filename) from get request 
  def download
    send_file @base_path + params[:type] + "s/" + params[:folder] + "/" + params[:name] + "." + params[:format],
      :type=> [params[:type], params[:format]].join("/"),
      :filename => [params[:name], params[:format]].join(".")
  end
end
