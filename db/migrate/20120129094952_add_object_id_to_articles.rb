class AddObjectIdToArticles < ActiveRecord::Migration
  def self.up
    add_column :articles, :object_id, :string
  end

  def self.down
    remove_column :articles, :object_id
  end
end
