class AddVideoToArticles < ActiveRecord::Migration
  def self.up
    add_column :articles, :video_link, :string
  end

  def self.down
    remove_column :articles, :video_link
  end
end
