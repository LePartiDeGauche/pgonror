class AddGenderToMemberships < ActiveRecord::Migration
  def change
    add_column :memberships, :gender, :string

  end
end
