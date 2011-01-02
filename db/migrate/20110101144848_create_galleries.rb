class CreateGalleries < ActiveRecord::Migration
  def self.up
    create_table :galleries do |t|
      ## BLOGABLE GENERATOR ##
      t.integer  "user_id"
      t.string   "title"
      t.text     "body"
      t.integer  "access_read_mask",   :default => 4
      t.integer  "access_manage_mask", :default => 4
      t.string   "locale",             :default => "en"
      t.integer  "ratings_count",      :default => 0
      t.float    "ratings_average",    :default => 0.0
      ## /BLOGABLE GENERATOR ##
    
      t.string :gallery_path
      t.boolean :is_public

      t.timestamps
    end
  end

  def self.down
    drop_table :galleries
  end
end
