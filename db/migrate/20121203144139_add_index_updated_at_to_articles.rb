class AddIndexUpdatedAtToArticles < ActiveRecord::Migration
  def up
    add_index :articles, [:updated_at]
  end

  def down
  end
end