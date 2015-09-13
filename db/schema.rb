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
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20150913194455) do

  create_table "book_users", force: true do |t|
    t.integer  "book_id"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "book_users", ["book_id"], name: "index_book_users_on_book_id", using: :btree
  add_index "book_users", ["user_id", "book_id"], name: "index_book_users_on_user_id_and_book_id", unique: true, using: :btree

  create_table "books", force: true do |t|
    t.text     "name"
    t.integer  "required_points"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "cover_file_name"
    t.string   "cover_content_type"
    t.integer  "cover_file_size"
    t.datetime "cover_updated_at"
    t.integer  "level"
    t.string   "thumb_file_name"
    t.string   "thumb_content_type"
    t.integer  "thumb_file_size"
    t.datetime "thumb_updated_at"
    t.integer  "tier"
    t.boolean  "visible",            default: true
    t.boolean  "active",             default: true
  end

  create_table "categories", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "category_challenges", force: true do |t|
    t.integer  "category_id"
    t.integer  "challenge_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "challenges", force: true do |t|
    t.integer  "point"
    t.text     "description_en"
    t.integer  "book_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "difficulty"
    t.text     "description_fr"
  end

  add_index "challenges", ["book_id"], name: "index_challenges_on_book_id", using: :btree

  create_table "comments", force: true do |t|
    t.text     "message",    limit: 16777215
    t.integer  "selfie_id"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "comments", ["selfie_id"], name: "index_comments_on_selfie_id", using: :btree
  add_index "comments", ["user_id"], name: "index_comments_on_user_id", using: :btree

  create_table "contacts", force: true do |t|
    t.string   "email"
    t.text     "message"
    t.integer  "type_contact"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "daily_challenges", force: true do |t|
    t.integer  "challenge_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "delayed_jobs", force: true do |t|
    t.integer  "priority",   default: 0, null: false
    t.integer  "attempts",   default: 0, null: false
    t.text     "handler",                null: false
    t.text     "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by"
    t.string   "queue"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "delayed_jobs", ["priority", "run_at"], name: "delayed_jobs_priority", using: :btree

  create_table "devices", force: true do |t|
    t.integer  "user_id"
    t.string   "token"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "type_device", default: 0
    t.boolean  "active",      default: true
  end

  add_index "devices", ["active"], name: "index_devices_on_active", using: :btree
  add_index "devices", ["token"], name: "index_devices_on_token", using: :btree
  add_index "devices", ["type_device"], name: "index_devices_on_type_device", using: :btree
  add_index "devices", ["user_id"], name: "index_devices_on_user_id", using: :btree

  create_table "facebook_infos", force: true do |t|
    t.integer  "user_id"
    t.string   "facebook_lastname"
    t.string   "facebook_firstname"
    t.string   "facebook_locale"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "facebook_infos", ["user_id"], name: "index_facebook_infos_on_user_id", using: :btree

  create_table "follows", force: true do |t|
    t.integer  "followable_id",                   null: false
    t.string   "followable_type",                 null: false
    t.integer  "follower_id",                     null: false
    t.string   "follower_type",                   null: false
    t.boolean  "blocked",         default: false, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "status",          default: 0
  end

  add_index "follows", ["followable_id", "followable_type"], name: "fk_followables", using: :btree
  add_index "follows", ["follower_id", "follower_type"], name: "fk_follows", using: :btree

  create_table "notifications", force: true do |t|
    t.text     "message_en",        limit: 16777215
    t.integer  "user_id"
    t.integer  "author_id"
    t.integer  "selfie_id"
    t.boolean  "read",                               default: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "book_id"
    t.text     "message_fr",        limit: 16777215
    t.integer  "type_notification",                  default: 0
  end

  add_index "notifications", ["author_id"], name: "index_notifications_on_author_id", using: :btree
  add_index "notifications", ["book_id"], name: "index_notifications_on_book_id", using: :btree
  add_index "notifications", ["created_at"], name: "index_notifications_on_created_at", using: :btree
  add_index "notifications", ["read"], name: "index_notifications_on_read", using: :btree
  add_index "notifications", ["selfie_id"], name: "index_notifications_on_selfie_id", using: :btree
  add_index "notifications", ["user_id"], name: "index_notifications_on_user_id", using: :btree

  create_table "rails_push_notifications_gcm_apps", force: true do |t|
    t.string   "gcm_key"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "rails_push_notifications_notifications", force: true do |t|
    t.text     "destinations"
    t.integer  "app_id"
    t.string   "app_type"
    t.text     "data"
    t.text     "results"
    t.integer  "success"
    t.integer  "failed"
    t.boolean  "sent",         default: false
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
  end

  create_table "selfies", force: true do |t|
    t.integer  "user_id"
    t.text     "message",            limit: 16777215
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "photo_file_name",    limit: 191
    t.string   "photo_content_type", limit: 191
    t.integer  "photo_file_size"
    t.datetime "photo_updated_at"
    t.integer  "challenge_id"
    t.boolean  "private",                             default: false
    t.integer  "approval_status",                     default: 0
    t.boolean  "shared_fb",                           default: false
    t.boolean  "is_daily",                            default: false
    t.integer  "flag_count",                          default: 0
    t.boolean  "blocked",                             default: false
    t.boolean  "hidden",                              default: false
    t.text     "photo_meta"
  end

  add_index "selfies", ["blocked"], name: "index_selfies_on_blocked", using: :btree
  add_index "selfies", ["challenge_id"], name: "index_selfies_on_challenge_id", using: :btree
  add_index "selfies", ["created_at"], name: "index_selfies_on_created_at", using: :btree
  add_index "selfies", ["hidden"], name: "index_selfies_on_hidden", using: :btree
  add_index "selfies", ["private"], name: "index_selfies_on_private", using: :btree
  add_index "selfies", ["user_id"], name: "index_selfies_on_user_id", using: :btree

  create_table "users", force: true do |t|
    t.string   "email",                  default: "",             null: false
    t.string   "encrypted_password",     default: "",             null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,              null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "authentication_token"
    t.string   "username",               default: "",             null: false
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.boolean  "from_facebook",          default: false
    t.boolean  "from_mobileapp",         default: false
    t.string   "firstname"
    t.string   "lastname"
    t.string   "avatar_file_name"
    t.string   "avatar_content_type"
    t.integer  "avatar_file_size"
    t.datetime "avatar_updated_at"
    t.string   "provider"
    t.string   "uid"
    t.text     "oauth_token"
    t.datetime "oauth_expires_at"
    t.string   "facebook_picture"
    t.integer  "points",                 default: 0
    t.string   "slug"
    t.integer  "administrator",          default: 0
    t.boolean  "username_activated",     default: true
    t.boolean  "blocked",                default: false
    t.string   "locale",                 default: "en"
    t.string   "timezone",               default: "Europe/Paris"
    t.integer  "daily_challenge_id"
  end

  add_index "users", ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true, using: :btree
  add_index "users", ["daily_challenge_id"], name: "index_users_on_daily_challenge_id", using: :btree
  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["locale"], name: "index_users_on_locale", using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  add_index "users", ["slug"], name: "index_users_on_slug", unique: true, using: :btree
  add_index "users", ["username"], name: "index_users_on_username", unique: true, using: :btree

  create_table "votes", force: true do |t|
    t.integer  "votable_id"
    t.string   "votable_type"
    t.integer  "voter_id"
    t.string   "voter_type"
    t.boolean  "vote_flag"
    t.string   "vote_scope"
    t.integer  "vote_weight"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "votes", ["votable_id", "votable_type", "vote_scope"], name: "index_votes_on_votable_id_and_votable_type_and_vote_scope", using: :btree
  add_index "votes", ["voter_id", "voter_type", "vote_scope"], name: "index_votes_on_voter_id_and_voter_type_and_vote_scope", using: :btree

end
