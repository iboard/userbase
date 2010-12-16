class AddLanguageToPostings < ActiveRecord::Migration
  def self.up
    add_column :postings, :locale, :string, :default => 'en'
  end

  def self.down
    remove_column :postings, :locale
  end
end
