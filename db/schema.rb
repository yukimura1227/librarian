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

ActiveRecord::Schema.define(version: 2019_09_23_030209) do

  create_table "books", force: :cascade do |t|
    t.string "title"
    t.text "location"
    t.integer "order_id"
    t.integer "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["order_id"], name: "index_books_on_order_id"
    t.index ["user_id"], name: "index_books_on_user_id"
  end

  create_table "operations", force: :cascade do |t|
    t.string "type"
    t.integer "user_id"
    t.integer "book_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["book_id"], name: "index_operations_on_book_id"
    t.index ["user_id"], name: "index_operations_on_user_id"
  end

  create_table "orders", force: :cascade do |t|
    t.integer "user_id"
    t.string "title"
    t.datetime "order_time"
    t.integer "state", default: 0
    t.text "url"
    t.text "origin_html"
    t.text "image_path"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_orders_on_user_id"
  end

  create_table "slack_members", force: :cascade do |t|
    t.string "slack_id"
    t.string "slack_user_name"
    t.integer "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["slack_user_name"], name: "index_slack_members_on_slack_user_name"
    t.index ["user_id"], name: "index_slack_members_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "name"
    t.string "uid"
    t.string "token"
    t.text "meta"
    t.string "provider"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

end
