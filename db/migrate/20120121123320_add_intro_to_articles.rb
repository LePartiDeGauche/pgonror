class AddIntroToArticles < ActiveRecord::Migration
  def self.up
    add_column :articles, :introduction, :string
  end

  def self.down
    remove_column :articles, :introduction
  end
end
