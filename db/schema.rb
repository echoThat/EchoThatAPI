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

ActiveRecord::Schema.define(version: 20150331174905) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "contact_forms", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "echos", force: :cascade do |t|
    t.integer  "user_id"
    t.string   "long_url"
    t.string   "short_url"
    t.boolean  "is_draft"
    t.text     "body"
    t.string   "send_to_venue"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "user_text"
    t.text     "quoted_content"
  end

  add_index "echos", ["short_url"], name: "index_echos_on_short_url", unique: true, using: :btree

  create_table "support_emails", force: :cascade do |t|
    t.string   "subject"
    t.text     "body",       null: false
    t.string   "sender",     null: false
    t.string   "recipient",  null: false
    t.datetime "sent_on"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "support_issues", force: :cascade do |t|
    t.string   "sender",     null: false
    t.text     "body"
    t.string   "to"
    t.string   "subject"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.boolean  "twitter_on"
    t.boolean  "facebook_on"
    t.integer  "facebook_char_floor"
    t.boolean  "always_link"
    t.string   "twitter_token"
    t.string   "twitter_token_secret"
    t.integer  "twitter_id"
    t.string   "twitter_name"
    t.text     "google_credentials"
    t.string   "chrome_token"
    t.string   "facebook_token"
    t.string   "facebook_token_secret"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users", ["chrome_token"], name: "index_users_on_chrome_token", unique: true, using: :btree

end
