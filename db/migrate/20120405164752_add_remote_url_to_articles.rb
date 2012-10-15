class AddRemoteUrlToArticles < ActiveRecord::Migration
  def change
    add_column :articles, :image_remote_url, :string
  end
end
