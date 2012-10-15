class MergeImageIntoArticle < ActiveRecord::Migration
  def up
      add_column :articles, :image_file_name, :string
      add_column :articles, :image_content_type, :string
      add_column :articles, :image_file_size, :integer
      add_column :articles, :image_updated_at, :datetime
  end

  def down
      remove_column :articles, :image_file_name
      remove_column :articles, :image_content_type
      remove_column :articles, :image_file_size
      remove_column :articles, :image_updated_at
  end
end
