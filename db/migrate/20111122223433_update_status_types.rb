class UpdateStatusTypes < ActiveRecord::Migration
  def up
    execute "update articles set status='off' where category='type'"
  end

  def down
  end
end
