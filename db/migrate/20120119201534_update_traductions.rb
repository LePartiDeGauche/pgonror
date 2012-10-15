class UpdateTraductions < ActiveRecord::Migration
  def up
    Article.update_all({:category => 'web'}, ['category in (?)', 'traduction'])
  end

  def down
  end
end
