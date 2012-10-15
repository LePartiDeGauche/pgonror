class CreateArticles < ActiveRecord::Migration
  def self.up
    create_table :articles do |t|
      t.string :title
      t.text :content
      t.string :signature
      t.integer :revision
      t.string :created_by
      t.string :updated_by
      t.timestamps
    end

    add_index :articles, :title
  end

  def self.down
    drop_table :articles
  end
end
