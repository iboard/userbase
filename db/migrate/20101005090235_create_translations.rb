class CreateTranslations < ActiveRecord::Migration
  def self.up
    create_table :translations do |t|
      t.string :locale
      t.integer :translateable_id
      t.string :translateable_type
      t.integer :translated_id

      t.timestamps
    end
  end

  def self.down
    drop_table :translations
  end
end
