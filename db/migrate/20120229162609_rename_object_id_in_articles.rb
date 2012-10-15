class RenameObjectIdInArticles < ActiveRecord::Migration
  def self.up
    add_column :articles, :external_id, :string
    remove_column :articles, :object_id
  end

  def self.down
    remove_column :articles, :object_id
    add_column :articles, :external_id, :string
  end
end
