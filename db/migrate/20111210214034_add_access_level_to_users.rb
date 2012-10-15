class AddAccessLevelToUsers < ActiveRecord::Migration
  def up
    add_column :users, :access_level, :string
  end

  def down
    remove_column :users, :access_level
  end
end
