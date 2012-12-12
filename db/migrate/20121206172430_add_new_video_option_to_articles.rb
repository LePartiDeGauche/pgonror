class AddNewVideoOptionToArticles < ActiveRecord::Migration
  def self.up
    add_column :articles, :home_video, :boolean
    add_index :articles, :home_video
  end

  def self.down
    remove_column :articles, :home_video
  end
end
