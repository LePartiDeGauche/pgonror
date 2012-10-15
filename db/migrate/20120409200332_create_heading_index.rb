class CreateHeadingIndex < ActiveRecord::Migration
  def up
    add_index :articles, [:heading]
  end

  def down
  end
end
