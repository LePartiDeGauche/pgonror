class DropImages < ActiveRecord::Migration
  def up
    drop_table :images
  end

  def down
    create_table :images do |t|
      t.string :image_file_name
      t.string :image_content_type
      t.integer :image_file_size
      t.datetime :images, :image_updated_at
      t.string :updated_by
      t.integer :lock_version, :default => 0
    end
  end
end
