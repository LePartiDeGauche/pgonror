class AddCommentsToAudits < ActiveRecord::Migration
  def change
    add_column :audits, :comments, :string
  end
end