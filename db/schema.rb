# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2021_05_06_193705) do

  create_table "contact_errors", force: :cascade do |t|
    t.text "line", null: false
    t.integer "line_number", null: false
    t.text "errors", null: false
    t.text "attempt", null: false
    t.integer "user_id", null: false
    t.integer "contact_file_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["contact_file_id"], name: "index_contact_errors_on_contact_file_id"
    t.index ["user_id"], name: "index_contact_errors_on_user_id"
  end

  create_table "contact_files", force: :cascade do |t|
    t.string "name", null: false
    t.string "status", null: false
    t.integer "lines", null: false
    t.text "columns", null: false
    t.integer "user_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["user_id"], name: "index_contact_files_on_user_id"
  end

  create_table "contacts", force: :cascade do |t|
    t.string "name", null: false
    t.date "birth", null: false
    t.string "phone", null: false
    t.string "address", null: false
    t.string "card", null: false
    t.string "card_nums", null: false
    t.string "franchise", null: false
    t.string "email", null: false
    t.integer "user_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["user_id"], name: "index_contacts_on_user_id"
  end

  add_foreign_key "contact_errors", "contact_files"
  add_foreign_key "contact_errors", "users"
  add_foreign_key "contact_files", "users"
  add_foreign_key "contacts", "users"
end
