class AddDateTimeFlagsInArticles < ActiveRecord::Migration
  def self.up
    add_column :articles, :no_endtime, :boolean
    add_column :articles, :all_day, :boolean
  end

  def self.down
    remove_column :articles, :no_endtime
    remove_column :articles, :all_day
  end
end
