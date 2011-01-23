class AddAccessMaskToEpisodes < ActiveRecord::Migration
  def self.up
    add_column :episodes, :access_read_mask, :integer,   :default => 2**User::ROLES.index('admin')
    add_column :episodes, :access_manage_mask, :integer, :default => 2**User::ROLES.index('admin')
  end

  def self.down
    remove_column :episodes, :access_manage_mask
    remove_column :episodes, :access_read_mask
  end
end
