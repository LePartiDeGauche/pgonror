class CreateMemberships < ActiveRecord::Migration
  def self.up
    create_table :memberships do |t|
      t.boolean  :renew
      t.string   :last_name, :limit => 30
      t.string   :first_name, :limit => 30
      t.string   :email, :limit => 30
      t.string   :address, :limit => 80
      t.string   :zip_code, :limit => 10
      t.string   :city, :limit => 30
      t.string   :phone, :limit => 30
      t.string   :department, :limit => 10
      t.string   :committee, :limit => 30
      t.date     :birthdate
      t.string   :job, :limit => 30
      t.string   :mandate, :limit => 80
      t.string   :union, :limit => 30
      t.string   :union_resp, :limit => 10
      t.string   :assoc, :limit => 30
      t.string   :assoc_resp, :limit => 10
      t.decimal  :amount, :precision => 4, :scale => 2
      t.text     :comment, :limit => 3000
      t.integer  :lock_version,        :default => 0
      t.timestamps
    end

    add_index :memberships, :updated_at
  end

  def self.down
    drop_table :memberships
  end
end
