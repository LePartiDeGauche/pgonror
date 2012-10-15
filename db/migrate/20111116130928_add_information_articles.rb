class AddInformationArticles < ActiveRecord::Migration
  def up
    add_column :articles, :draft, :boolean
    add_column :articles, :published_at, :date

    add_index :articles, :uri
    add_index :articles, [:published_at, :updated_at]
  end

  def down
    remove_column :users, :draft
    remove_column :users, :published_at
  end
end
