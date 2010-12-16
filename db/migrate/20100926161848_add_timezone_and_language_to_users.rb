class AddTimezoneAndLanguageToUsers < ActiveRecord::Migration

  
  def self.connection 
    User.connection 
  end
  
  def self.up
    add_column :users, :time_zone, :string, :default => 'UTC'
    add_column :users, :language, :string, :default => 'en'
  end

  def self.down
    remove_column :users, :language
    remove_column :users, :time_zone
  end
end
