class RemoveReferenceDateFromArticles < ActiveRecord::Migration
  def up
    remove_column :articles, :reference_date
  end

  def down
    add_column :articles, :reference_date, :date
  end
end
