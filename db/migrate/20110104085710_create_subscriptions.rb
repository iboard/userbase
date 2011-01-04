class CreateSubscriptions < ActiveRecord::Migration
  def self.up
    create_table :subscriptions do |t|
      t.integer :user_id
      t.string :name
      t.string :blogable_type
      t.string :tag_list
      t.boolean :notify, :default => true
      t.datetime :last_notified_at
      t.timestamps
    end
  end

  def self.down
    drop_table :subscriptions
  end
end
