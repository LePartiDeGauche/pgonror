class AddGeoCodesToArticles < ActiveRecord::Migration
  def self.up
    add_column :articles, :longitude, :float
    add_column :articles, :latitude, :float
  end

  def self.down
    remove_column :articles, :longitude
    remove_column :articles, :latitude
  end
end
