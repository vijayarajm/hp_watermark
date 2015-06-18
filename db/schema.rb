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

ActiveRecord::Schema.define(version: 20150618203554) do

  create_table "images", force: true do |t|
    t.integer  "project_id",            null: false
    t.string   "name"
    t.string   "description"
    t.string   "original_url"
    t.string   "final_url"
    t.string   "logo"
    t.integer  "height"
    t.integer  "width"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "original_file_name"
    t.string   "original_content_type"
    t.integer  "original_file_size"
    t.datetime "original_updated_at"
  end

  add_index "images", ["project_id"], name: "images_project_id_fk", using: :btree

  create_table "payoffs", force: true do |t|
    t.integer  "project_id",       null: false
    t.string   "name"
    t.string   "url"
    t.string   "remote_payoff_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "payoffs", ["project_id"], name: "payoffs_project_id_fk", using: :btree

  create_table "projects", force: true do |t|
    t.integer  "user_id",           null: false
    t.string   "name"
    t.string   "description"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "logo_file_name"
    t.string   "logo_content_type"
    t.integer  "logo_file_size"
    t.datetime "logo_updated_at"
  end

  add_index "projects", ["user_id"], name: "projects_user_id_fk", using: :btree

  create_table "regions", force: true do |t|
    t.integer  "image_id",             null: false
    t.integer  "payoff_id",            null: false
    t.string   "name"
    t.integer  "top_left_x"
    t.integer  "top_left_y"
    t.integer  "height"
    t.integer  "width"
    t.string   "original_url"
    t.integer  "watermark_strength"
    t.integer  "watermark_resolution"
    t.string   "remote_link_id"
    t.string   "remote_trigger_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "regions", ["image_id"], name: "regions_image_id_fk", using: :btree
  add_index "regions", ["payoff_id"], name: "regions_payoff_id_fk", using: :btree

  create_table "users", force: true do |t|
    t.string   "username"
    t.string   "email"
    t.string   "client_id"
    t.string   "client_secret"
    t.string   "crypted_password"
    t.string   "password_salt"
    t.string   "persistence_token"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "admin"
    t.string   "perishable_token"
  end

  add_foreign_key "images", "projects", name: "images_project_id_fk"

  add_foreign_key "payoffs", "projects", name: "payoffs_project_id_fk"

  add_foreign_key "projects", "users", name: "projects_user_id_fk"

  add_foreign_key "regions", "images", name: "regions_image_id_fk"
  add_foreign_key "regions", "payoffs", name: "regions_payoff_id_fk"

end
