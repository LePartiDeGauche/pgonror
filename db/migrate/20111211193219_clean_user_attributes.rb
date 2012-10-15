class CleanUserAttributes < ActiveRecord::Migration
  def up
    remove_column :users, :password
    remove_column :users, :salt
    remove_column :users, :locked
  end

  def down
    add_column :users, :password, :string
    add_column :users, :salt, :string
    add_column :users, :locked, :boolean
  end
end
