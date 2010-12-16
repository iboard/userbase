class CreateAssets < ActiveRecord::Migration
  def self.up
    create_table :assets do |t|
      t.integer  :assetable_id
      t.string   :assetable_type
      t.string   :title
      t.text     :description
      t.string   :asset_file_name
      t.string   :asset_content_type
      t.integer  :asset_file_size
      t.datetime :asset_updated_at
      t.timestamps
    end
  end

  def self.down
    drop_table :assets
  end
end
