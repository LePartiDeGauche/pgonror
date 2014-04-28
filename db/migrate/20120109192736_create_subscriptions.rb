class CreateSubscriptions < ActiveRecord::Migration
  def self.up
    create_table :subscriptions do |t|
      t.string   :last_name, :limit => 30
      t.string   :first_name, :limit => 30
      t.string   :email, :limit => 50
      t.string   :address, :limit => 80
      t.string   :zip_code, :limit => 10
      t.string   :city, :limit => 80
      t.string   :phone, :limit => 30
      t.integer  :lock_version,        :default => 0
      t.timestamps
    end

    add_index :subscriptions, :updated_at
  end

  def self.down
    drop_table :subscriptions
  end
end
