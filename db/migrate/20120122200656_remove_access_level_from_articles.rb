class RemoveAccessLevelFromArticles < ActiveRecord::Migration
  def self.up
    remove_column :articles, :access_level
  end

  def self.down
    add_column :articles, :access_level, :string
  end
end
