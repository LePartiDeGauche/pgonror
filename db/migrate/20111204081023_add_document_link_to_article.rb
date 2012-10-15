class AddDocumentLinkToArticle < ActiveRecord::Migration
  def up
      add_column :articles, :document_file_name, :string
      add_column :articles, :document_content_type, :string
      add_column :articles, :document_file_size, :integer
      add_column :articles, :document_updated_at, :datetime
  end

  def down
      remove_column :articles, :document_file_name
      remove_column :articles, :document_content_type
      remove_column :articles, :document_file_size
      remove_column :articles, :document_updated_at
  end
end
