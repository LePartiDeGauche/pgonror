class AddAttributestoArticles < ActiveRecord::Migration
  def up
    add_column :articles, :legacy, :boolean
    add_column :articles, :access_level, :string
    add_column :articles, :reference_date, :date
    add_column :articles, :start_datetime, :datetime
    add_column :articles, :end_datetime, :datetime
    add_column :articles, :address, :string
  end

  def down
    remove_column :articles, :legacy
    remove_column :articles, :access_level
    remove_column :articles, :reference_date
    remove_column :articles, :start_datetime
    remove_column :articles, :end_datetime
    remove_column :articles, :address
  end
end
