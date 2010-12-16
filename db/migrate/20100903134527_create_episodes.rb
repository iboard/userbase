class CreateEpisodes < ActiveRecord::Migration
  def self.up
    create_table :episodes do |t|
      t.string :title
      t.text :description
      t.string :video_web_url
      t.string :video_mobile_url
      t.integer :user_id

      t.timestamps
    end
  end

  def self.down
    drop_table :episodes
  end
end
