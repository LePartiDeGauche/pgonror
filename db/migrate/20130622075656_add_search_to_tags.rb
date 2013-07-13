class AddSearchToTags < ActiveRecord::Migration
  def self.up
    add_column :tags, :search, :string
    add_index :tags, [:search]

    for tag in Tag.all
      puts "-- Update tag #{tag.tag}"
      tag.transaction do
        tag.create_search
        tag.save!
      end
    end
  end

  def self.down
    remove_column :tags, :search
  end
end
