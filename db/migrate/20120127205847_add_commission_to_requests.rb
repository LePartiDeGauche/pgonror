class AddCommissionToRequests < ActiveRecord::Migration
  def self.up
    add_column :requests, :recipient, :string
  end

  def self.down
    remove_column :requests, :recipient
  end
end
