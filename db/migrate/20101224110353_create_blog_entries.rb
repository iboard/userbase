class CreateBlogEntries < ActiveRecord::Migration
  def self.up
    create_table :blog_entries do |t|
      t.integer :blog_entry_id
      t.string :blog_entry_type
      t.timestamps
    end
    
     BlogEntry.reset_column_information
     (Posting.all + Episode.all).each do |item|
       BlogEntry.create( :blog_entry_id => item.id, :blog_entry_type => item.class.to_s)
     end
  end

  def self.down
    drop_table :blog_entries
  end
end
