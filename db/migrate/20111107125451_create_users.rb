class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table :users do |t|
      t.string   :email
      t.string   :password
      t.string   :salt
      t.string   :created_by
      t.string   :updated_by
      t.boolean  :locked
      t.boolean  :administrator
      t.boolean  :publisher
      t.timestamps
    end
  end

  def self.down
    drop_table :users
  end
end
