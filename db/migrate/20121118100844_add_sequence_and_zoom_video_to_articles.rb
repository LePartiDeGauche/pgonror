class AddSequenceAndZoomVideoToArticles < ActiveRecord::Migration
  def up
    add_column :articles, :zoom_video, :boolean
    add_index :articles, [:zoom_video]
    add_column :articles, :zoom_sequence, :integer
    add_index :articles, [:zoom_sequence]
  end

  def down
    remove_column :articles, :zoom_video
    remove_column :articles, :zoom_sequence
  end
end
