class CreatePostings < ActiveRecord::Migration
  def self.up
    create_table :postings do |t|
      t.integer :user_id
      t.string :title
      t.text :body

      t.timestamps
    end
  end

  def self.down
    drop_table :postings
  end
end
