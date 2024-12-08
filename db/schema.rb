# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.2].define(version: 2024_11_15_152009) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "clients", id: :serial, force: :cascade do |t|
    t.string "name", limit: 100, null: false
    t.string "email", limit: 100, null: false
    t.string "phone", limit: 15, null: false
    t.text "address", null: false

    t.unique_constraint ["email"], name: "clients_email_key"
  end

  create_table "comments", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "publication_id", null: false
    t.text "content"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["publication_id"], name: "index_comments_on_publication_id"
    t.index ["user_id"], name: "index_comments_on_user_id"
  end

  create_table "machines", id: :serial, force: :cascade do |t|
    t.string "model", limit: 100, null: false
    t.string "serial_number", limit: 100, null: false
    t.string "status", limit: 50, null: false

    t.unique_constraint ["serial_number"], name: "machines_serial_number_key"
  end

  create_table "publications", force: :cascade do |t|
    t.string "title"
    t.text "description"
    t.boolean "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "category"
    t.string "references"
    t.bigint "user_id"
    t.index ["user_id"], name: "index_publications_on_user_id"
  end

  create_table "rentals", id: :serial, force: :cascade do |t|
    t.integer "client_id", null: false
    t.integer "machine_id", null: false
    t.date "start_date", null: false
    t.date "end_date", null: false
    t.string "status", limit: 50, null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string "unconfirmed_email"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "role"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "comments", "publications"
  add_foreign_key "comments", "users"
  add_foreign_key "publications", "users"
  add_foreign_key "rentals", "clients", name: "rentals_client_id_fkey", on_delete: :cascade
  add_foreign_key "rentals", "machines", name: "rentals_machine_id_fkey", on_delete: :cascade
end
