class UpdateHeadingFromParents < ActiveRecord::Migration
  def up
    execute "update articles set heading = (select a.title from articles a where a.id = articles.parent_id) where (heading is null or heading = '') and parent_id is not null;"
  end

  def down
  end
end
