class CreateDonations < ActiveRecord::Migration
  def self.up
    create_table :donations do |t|
      t.string   :last_name, :limit => 30
      t.string   :first_name, :limit => 30
      t.string   :email, :limit => 50
      t.string   :address, :limit => 80
      t.string   :zip_code, :limit => 10
      t.string   :city, :limit => 80
      t.string   :phone, :limit => 30
      t.decimal  :amount, :precision => 6, :scale => 2
      t.text     :comment, :limit => 3000
      t.integer  :lock_version,        :default => 0
      t.timestamps
    end

    add_index :donations, :updated_at
  end

  def self.down
    drop_table :donations
  end
end
