class AddMissingIndices201101 < ActiveRecord::Migration
  def self.up
    add_index "assets", ["assetable_id"], :name => "index_assets_on_assetable_id", :unique => false
    add_index "assets", ["assetable_type"], :name => "index_assets_on_assetable_type", :unique => false
    add_index "assets", ["asset_content_type"], :name => "index_assets_on_asset_content_type", :unique => false
    
    add_index "authentications", ["user_id"], :name => 'index_authentications_on_user_id', :unique => false
    add_index "authentications", ["provider"], :name => 'index_authentications_on_provider', :unique => false
    add_index "authentications", ["uid"], :name => 'index_authentications_on_uid', :unique => false
    
    add_index "blog_entries", ["blog_entry_id"], :name => 'index_blog_entries_on_blog_entry_id', :unique => false
    add_index "blog_entries", ["blog_entry_type"], :name => 'index_blog_entries_on_blog_entry_type', :unique => false
    
    add_index "episodes", ["user_id"], :name => 'index_episodes_on_user_id', :unique => false
    add_index "episodes", ["locale"], :name => 'index_episodes_on_locale', :unique => false
    #add_index "episodes", ["title"], :name => "index_episodes_on_title"
    add_index "episodes", ["access_read_mask"], :name =>   "index_episodes_on_access_read_mask", :unique => false
    add_index "episodes", ["access_manage_mask"], :name => "index_episodes_on_access_manage_mask", :unique => false
    
    add_index "galleries", ["user_id"], :name => "index_galleries_on_user_id", :unique => false
    add_index "galleries", ["access_read_mask"], :name => "index_galleries_on_access_read_mask", :unique => false
    add_index "galleries", ["access_manage_mask"], :name => "index_galleries_on_access_manage_mask", :unique => false
    add_index "galleries", ["ratings_count"], :name => "index_galleries_on_access_ratings_count", :unique => false
    add_index "galleries", ["ratings_average"], :name => "index_galleries_on_access_ratings_average", :unique => false
    
    #add_index "postings", ["title"], :name => "index_postings_on_title"
    #add_index "postings", ["user_id"], :name => "index_postings_on_user_id"
    add_index "postings", ["access_read_mask"],   :name => "index_postings_on_access_read_mask", :unique => false
    add_index "postings", ["access_manage_mask"], :name => "index_postings_on_access_manage_mask", :unique => false
    add_index "postings", ["ratings_count"],      :name => "index_postings_on_access_ratings_count", :unique => false
    add_index "postings", ["ratings_average"],    :name => "index_postings_on_access_ratings_average", :unique => false
    
    add_index "ratings", ["rateable_id"], :name => "index_ratings_on_rateable_id", :unique => false
    add_index "ratings", ["rateable_type"], :name => "index_ratings_on_rateable_type", :unique => false
    add_index "ratings", ["user_id"], :name => "index_ratings_on_user_id", :unique => false
    
    add_index "subscriptions", ["user_id"], :name => "index_subscriptions_on_user_id", :unique => false
    
    add_index "translations", ["locale"],          :name => "index_translations_on_locale", :unique => false
    add_index "translations", ["translateable_id"],:name => "index_translations_on_translateable_id", :unique => false
    add_index "translations", ["translateable_type"],:name => "index_translations_on_translateable_type", :unique => false
    add_index "translations", ["translated_id"],:name => "index_translations_on_translated_id", :unique => false
  end
  
  def self.down
    add_index :assets, :assetable_id
    add_index :assets, :assetable_type
    add_index :assets, :asset_content_type
    add_index :authentications, :user_id
    add_index :authentications, :provider
    add_index :authentications, :uid
    add_index :blog_entries, :blog_entry_id
    add_index :blog_entries, :blog_entry_type
    add_index :episodes, :user_id
    add_index :episodes, :locale
    add_index :episodes, :access_read_mask
    add_index :episodes, :access_manage_mask
    add_index :galleries, :user_id
    add_index :galleries, :access_read_mask
    add_index :galleries, :access_manage_mask
    add_index :galleries, :ratings_count
    add_index :galleries, :ratings_average
    add_index :postings, :access_read_mask
    add_index :postings, :access_manage_mask
    add_index :postings, :ratings_count
    add_index :postings, :ratings_average
    add_index :ratings, :rateable_id
    add_index :ratings, :rateable_type
    add_index :ratings, :user_id
    add_index :subscriptions, :user_id
    add_index :translations, :locale
    add_index :translations, :translateable_id
    add_index :translations, :translateable_type
    add_index :translations, :translated_id
  end
   
end