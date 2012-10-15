class AddNotificationsToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :notification_message, :boolean
    add_column :users, :notification_subscription, :boolean
    add_column :users, :notification_donation, :boolean
    add_column :users, :notification_membership, :boolean
  end

  def self.down
    remove_column :users, :notification_message
    remove_column :users, :notification_subscription
    remove_column :users, :notification_donation
    remove_column :users, :notification_membership
  end
end
