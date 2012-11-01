class AddShowHeadingToArticle < ActiveRecord::Migration
  def up
    add_column :articles, :show_heading, :boolean
    add_index :articles, [:show_heading]
    execute "update articles set show_heading='t' where category='legislative'"
  end

  def down
    remove_column :articles, :show_heading
  end
end