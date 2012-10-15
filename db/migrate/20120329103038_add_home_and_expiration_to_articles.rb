class AddHomeAndExpirationToArticles < ActiveRecord::Migration
  def up
    add_column :articles, :expired_at, :date
    add_column :articles, :zoom, :boolean
    add_index :articles, [:expired_at]
    add_index :articles, [:zoom]
    execute "update articles set expired_at='2099-12-31'"
    execute "update articles set zoom='t' where category='actu'"
  end

  def down
    remove_column :articles, :expired_at
    remove_column :articles, :zoom
  end
end