class AddHeadingToArticles < ActiveRecord::Migration
  def self.up
    add_column :articles, :heading, :string
  end

  def self.down
    remove_column :articles, :heading
  end
end
