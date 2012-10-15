class CleanUpCategories < ActiveRecord::Migration
  def up
    execute "delete from articles where category='type'"
  end

  def down
  end
end
