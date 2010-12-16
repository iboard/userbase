class AddLocaleToEpisodes < ActiveRecord::Migration
  def self.up
    add_column :episodes, :locale, :string, :default => 'en'
  end

  def self.down
    remove_column :episodes, :locale
  end
end
