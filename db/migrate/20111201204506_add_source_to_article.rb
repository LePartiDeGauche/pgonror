class AddSourceToArticle < ActiveRecord::Migration
  def self.up
    add_column :articles, :source_id, :integer
  end

  def self.down
    remove_column :articles, :source_id
  end
end
