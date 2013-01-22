class AddAlertNotificationToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :notification_alert, :boolean
  end

  def self.down
    remove_column :users, :notification_alert
  end
end
