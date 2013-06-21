class AddCountryToMemberDonation < ActiveRecord::Migration
  def self.up
    add_column :memberships, :country, :string
    add_column :donations, :country, :string
    add_column :requests, :country, :string
  end

  def self.down
    remove_column :memberships, :country
    remove_column :donations, :country
    remove_column :requests, :country
  end
end
