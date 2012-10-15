class CreatePermissions < ActiveRecord::Migration
  def self.up
    create_table :permissions do |t|
      t.integer :user_id
      t.integer :source_id
      t.string :category
      t.string :authorization
      t.string :notification_level
      t.string :created_by
      t.string :updated_by
      t.integer  :lock_version,        :default => 0
      t.timestamps
    end

    add_index :permissions, :user_id
  end

  def self.down
    drop_table :permissions
  end
end
