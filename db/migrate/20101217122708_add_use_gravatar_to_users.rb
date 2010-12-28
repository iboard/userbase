class AddUseGravatarToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :use_gravatar, :boolean, :default => false
  end

  def self.down
    remove_column :users, :use_gravatar
  end
end
