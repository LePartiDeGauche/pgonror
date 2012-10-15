class CreateAudit < ActiveRecord::Migration
  def self.up
    create_table :audits do |t|
      t.integer  :article_id
      t.string   :status
      t.string   :updated_by
      t.integer  :lock_version,        :default => 0
      t.timestamps
    end

    add_index :audits, [:article_id, :updated_at]
  end

  def self.down
    drop_table :audits
  end
end
