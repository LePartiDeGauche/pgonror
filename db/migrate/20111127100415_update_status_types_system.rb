class UpdateStatusTypesSystem < ActiveRecord::Migration
  def up
    execute "update articles set status='system' where category='type'"
    execute "update articles set status='hidden' where category='type' and uri='type'"
  end

  def down
  end
end
