class UpdateTraductions < ActiveRecord::Migration
  def up
    Article.where('category in (?)', 'traduction').update_all(category: 'web') 
  end

  def down
  end
end
