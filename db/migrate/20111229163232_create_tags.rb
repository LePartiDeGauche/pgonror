class CreateTags < ActiveRecord::Migration
  def self.up
    create_table :tags do |t|
      t.integer :article_id
      t.string :tag
      t.string :created_by
      t.string :updated_by
      t.integer  :lock_version,        :default => 0
      t.timestamps
    end

    add_index :tags, :article_id
    add_index :tags, :tag
  end

  def self.down
    drop_table :tags
  end
end
