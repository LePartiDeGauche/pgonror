class UpdatePaymentInformation < ActiveRecord::Migration
  def self.up
    remove_column :memberships, :paybox_answer
    remove_column :memberships, :paybox_message
    add_column :memberships, :payment_error, :string
    add_column :memberships, :payment_authorization, :string
    add_column :donations, :payment_error, :string
    add_column :donations, :payment_authorization, :string
  end

  def self.down
    add_column :memberships, :paybox_answer, :string
    add_column :memberships, :paybox_message, :string
    remove_column :memberships, :payment_error
    remove_column :memberships, :payment_authorization
    remove_column :donations, :payment_error
    remove_column :donations, :payment_authorization
  end
end