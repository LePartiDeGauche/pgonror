class AddLockVersion < ActiveRecord::Migration
  def self.up
    add_column :users, :lock_version, :integer, :default => 0
    add_column :articles, :lock_version, :integer, :default => 0
    remove_column :articles, :revision
    add_column :articles, :uri, :string
    add_column :articles, :parent_id, :integer
  end

  def self.down
    remove_column :users, :lock_version
    remove_column :articles, :lock_version
    add_column :articles, :revision, :integer
    remove_column :articles, :uri
    remove_column :articles, :parent_id
  end
end
