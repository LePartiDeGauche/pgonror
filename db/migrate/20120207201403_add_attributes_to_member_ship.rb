class AddAttributesToMemberShip < ActiveRecord::Migration
  def self.up
    add_column :memberships, :mandate_place, :string
    add_column :memberships, :mobile, :string
  end

  def self.down
    remove_column :memberships, :mandate_place
    remove_column :memberships, :mobile
  end
end
