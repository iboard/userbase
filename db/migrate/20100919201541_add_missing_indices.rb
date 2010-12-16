class AddMissingIndices < ActiveRecord::Migration
  def self.up
    
    # Postings indices
    add_index :postings, :title,             :unique => false
    add_index :postings, :user_id,           :unique => false

    # Comments
    add_index :comments, :commentable_id,    :unique => false
    add_index :comments, :commentable_type,  :unique => false    
    
    # Episodes
    add_index :episodes, :title,             :unique => false
  end

  def self.down
    remove_index :postings, :user_id
    remove_index :postings, :title
    remove_index :comments, :commentable_type
    remove_index :comments, :commentable_id
    remove_index :episodes, :title
  end
end
