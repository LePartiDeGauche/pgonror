class AddIndexExternalIdToArticle < ActiveRecord::Migration
  def self.up
    add_index :articles, [:external_id]
  end

  def self.down
  end
end
