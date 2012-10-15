class CreateImages < ActiveRecord::Migration
  def up
    create_table :images do |t|
      t.string :image_file_name
      t.string :image_content_type
      t.integer :image_file_size
      t.datetime :images, :image_updated_at
      t.string :updated_by
      t.integer :lock_version, :default => 0
    end
    add_index :images, :image_file_name
  end

  def down
    drop_table :images
  end
end