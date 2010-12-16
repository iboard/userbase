class CreateComments < ActiveRecord::Migration
  def self.up
    create_table :comments do |t|
      t.integer :commentable_id
      t.string :commentable_type
      t.integer :user_id
      t.string :email
      t.string :ip_address
      t.text :comment

      t.timestamps
    end
  end

  def self.down
    drop_table :comments
  end
end
