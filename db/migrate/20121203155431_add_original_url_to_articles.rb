class AddOriginalUrlToArticles < ActiveRecord::Migration
  def self.up
    add_column :articles, :original_url, :string
  end

  def self.down
    remove_column :articles, :original_url
  end
end
