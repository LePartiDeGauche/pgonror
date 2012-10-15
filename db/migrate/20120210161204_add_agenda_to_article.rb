class AddAgendaToArticle < ActiveRecord::Migration
  def up
    add_column :articles, :agenda, :boolean
    add_index :articles, :agenda
  end

  def down
    remove_column :articles, :agenda
  end
end
