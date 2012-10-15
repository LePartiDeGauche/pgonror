class RemoveVideoLinkFromArticle < ActiveRecord::Migration
  def self.up
    remove_column :articles, :video_link
  end

  def self.down
    add_column :articles, :video_link, :string
  end
end
