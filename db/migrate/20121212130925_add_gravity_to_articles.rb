class AddGravityToArticles < ActiveRecord::Migration
  def up
    add_column :articles, :gravity, :string
  end

  def down
    remove_column :articles, :gravity
  end
end
