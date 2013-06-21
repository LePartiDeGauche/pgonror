# encoding: UTF-8
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

ActiveRecord::Schema.define(:version => 20130506111338) do

  create_table "articles", :force => true do |t|
    t.string   "title"
    t.text     "content"
    t.string   "signature"
    t.string   "created_by"
    t.string   "updated_by"
    t.datetime "created_at",                           :null => false
    t.datetime "updated_at",                           :null => false
    t.string   "category"
    t.string   "status"
    t.integer  "lock_version",          :default => 0
    t.string   "uri"
    t.integer  "parent_id"
    t.boolean  "draft"
    t.date     "published_at"
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
    t.integer  "source_id"
    t.string   "document_file_name"
    t.string   "document_content_type"
    t.integer  "document_file_size"
    t.datetime "document_updated_at"
    t.boolean  "legacy"
    t.datetime "start_datetime"
    t.datetime "end_datetime"
    t.string   "address"
    t.string   "heading"
    t.string   "introduction"
    t.string   "email"
    t.boolean  "agenda"
    t.string   "external_id"
    t.boolean  "no_endtime"
    t.boolean  "all_day"
    t.date     "expired_at"
    t.boolean  "zoom"
    t.string   "image_remote_url"
    t.boolean  "show_heading"
    t.boolean  "zoom_video"
    t.integer  "zoom_sequence"
    t.string   "original_url"
    t.boolean  "home_video"
    t.string   "gravity"
    t.float    "longitude"
    t.float    "latitude"
    t.string   "audio_file_name"
    t.string   "audio_content_type"
    t.integer  "audio_file_size"
    t.datetime "audio_updated_at"
  end

  add_index "articles", ["agenda"], :name => "index_articles_on_agenda"
  add_index "articles", ["category"], :name => "index_articles_on_category"
  add_index "articles", ["expired_at"], :name => "index_articles_on_expired_at"
  add_index "articles", ["external_id"], :name => "index_articles_on_external_id"
  add_index "articles", ["heading"], :name => "index_articles_on_heading"
  add_index "articles", ["home_video"], :name => "index_articles_on_home_video"
  add_index "articles", ["published_at", "updated_at"], :name => "index_articles_on_published_at_and_updated_at"
  add_index "articles", ["show_heading"], :name => "index_articles_on_show_heading"
  add_index "articles", ["status"], :name => "index_articles_on_status"
  add_index "articles", ["title"], :name => "index_articles_on_title"
  add_index "articles", ["updated_at"], :name => "index_articles_on_updated_at"
  add_index "articles", ["uri"], :name => "index_articles_on_uri"
  add_index "articles", ["zoom"], :name => "index_articles_on_zoom"
  add_index "articles", ["zoom_sequence"], :name => "index_articles_on_zoom_sequence"
  add_index "articles", ["zoom_video"], :name => "index_articles_on_zoom_video"

  create_table "audits", :force => true do |t|
    t.integer  "article_id"
    t.string   "status"
    t.string   "updated_by"
    t.integer  "lock_version", :default => 0
    t.datetime "created_at",                  :null => false
    t.datetime "updated_at",                  :null => false
    t.string   "comments"
  end

  add_index "audits", ["article_id", "updated_at"], :name => "index_audits_on_article_id_and_updated_at"

  create_table "donations", :force => true do |t|
    t.string   "last_name",             :limit => 30
    t.string   "first_name",            :limit => 30
    t.string   "email",                 :limit => 30
    t.string   "address",               :limit => 80
    t.string   "zip_code",              :limit => 10
    t.string   "city",                  :limit => 30
    t.string   "phone",                 :limit => 30
    t.decimal  "amount",                                :precision => 4, :scale => 2
    t.text     "comment",               :limit => 3000
    t.integer  "lock_version",                                                        :default => 0
    t.datetime "created_at",                                                                         :null => false
    t.datetime "updated_at",                                                                         :null => false
    t.string   "payment_error"
    t.string   "payment_authorization"
    t.string   "country"
  end

  add_index "donations", ["updated_at"], :name => "index_donations_on_updated_at"

  create_table "memberships", :force => true do |t|
    t.boolean  "renew"
    t.string   "last_name",             :limit => 30
    t.string   "first_name",            :limit => 30
    t.string   "email",                 :limit => 30
    t.string   "address",               :limit => 80
    t.string   "zip_code",              :limit => 10
    t.string   "city",                  :limit => 30
    t.string   "phone",                 :limit => 30
    t.string   "department",            :limit => 10
    t.string   "committee",             :limit => 30
    t.date     "birthdate"
    t.string   "job",                   :limit => 30
    t.string   "mandate",               :limit => 80
    t.string   "union",                 :limit => 30
    t.string   "union_resp",            :limit => 10
    t.string   "assoc",                 :limit => 30
    t.string   "assoc_resp",            :limit => 10
    t.decimal  "amount",                                :precision => 4, :scale => 2
    t.text     "comment",               :limit => 3000
    t.integer  "lock_version",                                                        :default => 0
    t.datetime "created_at",                                                                         :null => false
    t.datetime "updated_at",                                                                         :null => false
    t.string   "mandate_place"
    t.string   "mobile"
    t.string   "payment_error"
    t.string   "payment_authorization"
    t.string   "gender"
    t.string   "country"
  end

  add_index "memberships", ["updated_at"], :name => "index_memberships_on_updated_at"

  create_table "permissions", :force => true do |t|
    t.integer  "user_id"
    t.integer  "source_id"
    t.string   "category"
    t.string   "authorization"
    t.string   "notification_level"
    t.string   "created_by"
    t.string   "updated_by"
    t.integer  "lock_version",       :default => 0
    t.datetime "created_at",                        :null => false
    t.datetime "updated_at",                        :null => false
  end

  add_index "permissions", ["user_id"], :name => "index_permissions_on_user_id"

  create_table "requests", :force => true do |t|
    t.string   "last_name",    :limit => 30
    t.string   "first_name",   :limit => 30
    t.string   "email",        :limit => 30
    t.string   "address",      :limit => 80
    t.string   "zip_code",     :limit => 10
    t.string   "city",         :limit => 30
    t.string   "phone",        :limit => 30
    t.text     "comment",      :limit => 3000
    t.integer  "lock_version",                 :default => 0
    t.datetime "created_at",                                  :null => false
    t.datetime "updated_at",                                  :null => false
    t.string   "recipient"
    t.string   "country"
  end

  add_index "requests", ["updated_at"], :name => "index_requests_on_updated_at"

  create_table "subscriptions", :force => true do |t|
    t.string   "last_name",    :limit => 30
    t.string   "first_name",   :limit => 30
    t.string   "email",        :limit => 30
    t.string   "address",      :limit => 80
    t.string   "zip_code",     :limit => 10
    t.string   "city",         :limit => 30
    t.string   "phone",        :limit => 30
    t.integer  "lock_version",               :default => 0
    t.datetime "created_at",                                :null => false
    t.datetime "updated_at",                                :null => false
  end

  add_index "subscriptions", ["updated_at"], :name => "index_subscriptions_on_updated_at"

  create_table "tags", :force => true do |t|
    t.integer  "article_id"
    t.string   "tag"
    t.string   "created_by"
    t.string   "updated_by"
    t.integer  "lock_version", :default => 0
    t.datetime "created_at",                  :null => false
    t.datetime "updated_at",                  :null => false
  end

  add_index "tags", ["article_id"], :name => "index_tags_on_article_id"
  add_index "tags", ["tag"], :name => "index_tags_on_tag"

  create_table "users", :force => true do |t|
    t.string   "email"
    t.string   "created_by"
    t.string   "updated_by"
    t.boolean  "administrator"
    t.boolean  "publisher"
    t.datetime "created_at",                                               :null => false
    t.datetime "updated_at",                                               :null => false
    t.integer  "lock_version",                             :default => 0
    t.string   "access_level"
    t.string   "encrypted_password",        :limit => 128, :default => "", :null => false
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email"
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                            :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.boolean  "notification_message"
    t.boolean  "notification_subscription"
    t.boolean  "notification_donation"
    t.boolean  "notification_membership"
    t.integer  "failed_attempts",                          :default => 0
    t.string   "unlock_token"
    t.datetime "locked_at"
    t.boolean  "notification_alert"
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

end
