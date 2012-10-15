class AddCategoryToArticles < ActiveRecord::Migration
  def self.up
    add_column :articles, :category, :string
    add_column :articles, :status, :string
    add_index :articles, [:category]
    add_index :articles, [:status]
  end

  def self.down
    remove_column :articles, :category
    remove_column :articles, :status
  end
end
