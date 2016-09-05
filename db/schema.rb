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

ActiveRecord::Schema.define(version: 20160819045036) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "fields", force: :cascade do |t|
    t.string   "name"
    t.string   "otype",      default: "text"
    t.boolean  "enabled",    default: false
    t.boolean  "ok",         default: false
    t.boolean  "unique",     default: false
    t.boolean  "required",   default: false
    t.json     "setting"
    t.integer  "project_id",                  null: false
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
  end

  add_index "fields", ["project_id", "name"], name: "index_fields_on_project_id_and_name", unique: true, using: :btree

  create_table "plugins", force: :cascade do |t|
    t.string   "name"
    t.json     "setting"
    t.string   "class_name"
    t.integer  "user_id"
    t.boolean  "test",       default: false
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
  end

  create_table "projects", force: :cascade do |t|
    t.string   "name",                       null: false
    t.string   "url",                        null: false
    t.string   "status",     default: "new", null: false
    t.string   "group"
    t.json     "setting",    default: {}
    t.json     "result",     default: {}
    t.integer  "progress",   default: 0
    t.boolean  "tasking",    default: false
    t.integer  "interval",   default: 1800
    t.integer  "pid"
    t.integer  "user_id",                    null: false
    t.datetime "start_at"
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
  end

  add_index "projects", ["group"], name: "index_projects_on_group", using: :btree
  add_index "projects", ["user_id"], name: "index_projects_on_user_id", using: :btree

  create_table "results", force: :cascade do |t|
    t.text     "result_text"
    t.text     "result_arr",  default: [],                 array: true
    t.integer  "result_int"
    t.boolean  "success",     default: false
    t.string   "log"
    t.integer  "url_id",                      null: false
    t.integer  "field_id",                    null: false
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
  end

  add_index "results", ["url_id", "field_id"], name: "index_results_on_url_id_and_field_id", unique: true, using: :btree

  create_table "urls", force: :cascade do |t|
    t.string   "url",                        null: false
    t.boolean  "skip",       default: false
    t.boolean  "parse",      default: false
    t.boolean  "duble",      default: false
    t.string   "log"
    t.string   "sha"
    t.integer  "duble_id"
    t.integer  "project_id",                 null: false
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
  end

  add_index "urls", ["duble_id"], name: "index_urls_on_duble_id", using: :btree
  add_index "urls", ["project_id", "url"], name: "index_urls_on_project_id_and_url", unique: true, using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "email",                  default: "",    null: false
    t.string   "encrypted_password",     default: "",    null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,     null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email"
    t.boolean  "admin",                  default: false
    t.datetime "created_at",                             null: false
    t.datetime "updated_at",                             null: false
  end

  add_index "users", ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true, using: :btree
  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

end
