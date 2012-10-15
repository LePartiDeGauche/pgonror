class AddPayBoxToMembership < ActiveRecord::Migration
  def self.up
    add_column :memberships, :paybox_answer, :string
    add_column :memberships, :paybox_message, :string
  end

  def self.down
    remove_column :memberships, :paybox_answer
    remove_column :memberships, :paybox_message
  end
end
