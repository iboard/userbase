# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20110105202200) do

  create_table "assets", :force => true do |t|
    t.integer  "assetable_id"
    t.string   "assetable_type"
    t.string   "title"
    t.text     "description"
    t.string   "asset_file_name"
    t.string   "asset_content_type"
    t.integer  "asset_file_size"
    t.datetime "asset_updated_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "assets", ["asset_content_type"], :name => "index_assets_on_asset_content_type"
  add_index "assets", ["assetable_id"], :name => "index_assets_on_assetable_id"
  add_index "assets", ["assetable_type"], :name => "index_assets_on_assetable_type"

  create_table "authentications", :force => true do |t|
    t.integer  "user_id"
    t.string   "provider"
    t.string   "uid"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "authentications", ["provider"], :name => "index_authentications_on_provider"
  add_index "authentications", ["uid"], :name => "index_authentications_on_uid"
  add_index "authentications", ["user_id"], :name => "index_authentications_on_user_id"

  create_table "blog_entries", :force => true do |t|
    t.integer  "blog_entry_id"
    t.string   "blog_entry_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "blog_entries", ["blog_entry_id"], :name => "index_blog_entries_on_blog_entry_id"
  add_index "blog_entries", ["blog_entry_type"], :name => "index_blog_entries_on_blog_entry_type"

  create_table "comments", :force => true do |t|
    t.integer  "commentable_id"
    t.string   "commentable_type"
    t.integer  "user_id"
    t.string   "email"
    t.string   "ip_address"
    t.text     "comment"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "comments", ["commentable_id"], :name => "index_comments_on_commentable_id"
  add_index "comments", ["commentable_type"], :name => "index_comments_on_commentable_type"

  create_table "delayed_jobs", :force => true do |t|
    t.integer  "priority",   :default => 0
    t.integer  "attempts",   :default => 0
    t.text     "handler"
    t.string   "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "episodes", :force => true do |t|
    t.string   "title"
    t.text     "description"
    t.string   "video_web_url"
    t.string   "video_mobile_url"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "access_read_mask",   :default => 4
    t.integer  "access_manage_mask", :default => 4
    t.string   "locale",             :default => "en"
    t.integer  "ratings_count",      :default => 0
    t.float    "ratings_average",    :default => 0.0
  end

  add_index "episodes", ["access_manage_mask"], :name => "index_episodes_on_access_manage_mask"
  add_index "episodes", ["access_read_mask"], :name => "index_episodes_on_access_read_mask"
  add_index "episodes", ["locale"], :name => "index_episodes_on_locale"
  add_index "episodes", ["title"], :name => "index_episodes_on_title"
  add_index "episodes", ["user_id"], :name => "index_episodes_on_user_id"

  create_table "galleries", :force => true do |t|
    t.integer  "user_id"
    t.string   "title"
    t.text     "body"
    t.integer  "access_read_mask",   :default => 4
    t.integer  "access_manage_mask", :default => 4
    t.string   "locale",             :default => "en"
    t.integer  "ratings_count",      :default => 0
    t.float    "ratings_average",    :default => 0.0
    t.string   "gallery_path"
    t.boolean  "is_public"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "galleries", ["access_manage_mask"], :name => "index_galleries_on_access_manage_mask"
  add_index "galleries", ["access_read_mask"], :name => "index_galleries_on_access_read_mask"
  add_index "galleries", ["ratings_average"], :name => "index_galleries_on_access_ratings_average"
  add_index "galleries", ["ratings_count"], :name => "index_galleries_on_access_ratings_count"
  add_index "galleries", ["user_id"], :name => "index_galleries_on_user_id"

  create_table "postings", :force => true do |t|
    t.integer  "user_id"
    t.string   "title"
    t.text     "body"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "access_read_mask",   :default => 4
    t.integer  "access_manage_mask", :default => 4
    t.string   "locale",             :default => "en"
    t.integer  "ratings_count",      :default => 0
    t.float    "ratings_average",    :default => 0.0
  end

  add_index "postings", ["access_manage_mask"], :name => "index_postings_on_access_manage_mask"
  add_index "postings", ["access_read_mask"], :name => "index_postings_on_access_read_mask"
  add_index "postings", ["ratings_average"], :name => "index_postings_on_access_ratings_average"
  add_index "postings", ["ratings_count"], :name => "index_postings_on_access_ratings_count"
  add_index "postings", ["title"], :name => "index_postings_on_title"
  add_index "postings", ["user_id"], :name => "index_postings_on_user_id"

  create_table "ratings", :force => true do |t|
    t.integer  "rateable_id"
    t.string   "rateable_type"
    t.integer  "user_id"
    t.integer  "rating"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "ratings", ["rateable_id"], :name => "index_ratings_on_rateable_id"
  add_index "ratings", ["rateable_type"], :name => "index_ratings_on_rateable_type"
  add_index "ratings", ["user_id"], :name => "index_ratings_on_user_id"

  create_table "subscriptions", :force => true do |t|
    t.integer  "user_id"
    t.string   "name"
    t.string   "blogable_type"
    t.string   "tag_list"
    t.boolean  "notify",           :default => true
    t.datetime "last_notified_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "subscriptions", ["user_id"], :name => "index_subscriptions_on_user_id"

  create_table "taggings", :force => true do |t|
    t.integer  "tag_id"
    t.integer  "taggable_id"
    t.string   "taggable_type"
    t.integer  "tagger_id"
    t.string   "tagger_type"
    t.string   "context"
    t.datetime "created_at"
  end

  add_index "taggings", ["tag_id"], :name => "index_taggings_on_tag_id"
  add_index "taggings", ["taggable_id", "taggable_type", "context"], :name => "index_taggings_on_taggable_id_and_taggable_type_and_context"

  create_table "tags", :force => true do |t|
    t.string "name"
  end

  create_table "translations", :force => true do |t|
    t.string   "locale"
    t.integer  "translateable_id"
    t.string   "translateable_type"
    t.integer  "translated_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "translations", ["locale"], :name => "index_translations_on_locale"
  add_index "translations", ["translateable_id"], :name => "index_translations_on_translateable_id"
  add_index "translations", ["translateable_type"], :name => "index_translations_on_translateable_type"
  add_index "translations", ["translated_id"], :name => "index_translations_on_translated_id"

  create_table "users", :force => true do |t|
    t.string   "email",                               :default => "",    :null => false
    t.string   "encrypted_password",   :limit => 128, :default => "",    :null => false
    t.string   "password_salt",                       :default => "",    :null => false
    t.string   "reset_password_token"
    t.string   "remember_token"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                       :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.integer  "failed_attempts",                     :default => 0
    t.string   "unlock_token"
    t.datetime "locked_at"
    t.string   "authentication_token"
    t.integer  "roles_mask",                          :default => 1
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "nickname"
    t.string   "avatar_file_name"
    t.string   "avatar_content_type"
    t.integer  "avatar_file_size"
    t.datetime "avatar_updated_at"
    t.string   "time_zone",                           :default => "UTC"
    t.string   "language",                            :default => "en"
    t.boolean  "use_gravatar",                        :default => false
  end

  add_index "users", ["confirmation_token"], :name => "index_users_on_confirmation_token", :unique => true
  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true
  add_index "users", ["unlock_token"], :name => "index_users_on_unlock_token", :unique => true

end
