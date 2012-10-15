class AddEmailToArticles < ActiveRecord::Migration
  def self.up
    add_column :articles, :email, :string
  end

  def self.down
    remove_column :articles, :email
  end
end
