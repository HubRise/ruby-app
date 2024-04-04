# frozen_string_literal: true
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

ActiveRecord::Schema[7.0].define(version: 2021_04_19_120038) do
  create_table "accounts", force: :cascade do |t|
    t.string("hr_id", null: false)
    t.datetime("refreshed_at", precision: nil, null: false)
    t.json("api_data")
    t.index(["hr_id"], name: "index_accounts_on_hr_id", unique: true)
  end

  create_table "app_instances", force: :cascade do |t|
    t.string("hr_id", null: false)
    t.string("hr_account_id")
    t.string("hr_location_id")
    t.string("hr_catalog_id")
    t.string("hr_customer_list_id")
    t.string("access_token", null: false)
    t.index(["hr_account_id"], name: "index_app_instances_on_hr_account_id")
    t.index(["hr_id"], name: "index_app_instances_on_hr_id", unique: true)
    t.index(["hr_location_id"], name: "index_app_instances_on_hr_location_id")
  end

  create_table "catalogs", force: :cascade do |t|
    t.string("hr_id", null: false)
    t.json("api_data")
    t.datetime("refreshed_at", precision: nil, null: false)
    t.index(["hr_id"], name: "index_catalogs_on_hr_id", unique: true)
  end

  create_table "customer_lists", force: :cascade do |t|
    t.string("hr_id", null: false)
    t.json("api_data")
    t.datetime("refreshed_at", precision: nil, null: false)
    t.index(["hr_id"], name: "index_customer_lists_on_hr_id", unique: true)
  end

  create_table "locations", force: :cascade do |t|
    t.string("hr_id", null: false)
    t.datetime("refreshed_at", precision: nil, null: false)
    t.json("api_data")
    t.index(["hr_id"], name: "index_locations_on_hr_id", unique: true)
  end

  create_table "user_app_instances", force: :cascade do |t|
    t.string("hr_user_id")
    t.string("hr_app_instance_id")
    t.datetime("refreshed_at", precision: nil, null: false)
    t.index(["hr_app_instance_id"], name: "index_user_app_instances_on_hr_app_instance_id")
    t.index(["hr_user_id", "hr_app_instance_id", "refreshed_at"], name: "index_user_app_instances")
    t.index(["hr_user_id"], name: "index_user_app_instances_on_hr_user_id")
  end

  create_table "users", force: :cascade do |t|
    t.string("hr_id", null: false)
    t.string("access_token", null: false)
    t.string("email")
    t.string("first_name")
    t.string("last_name")
    t.string("locales")
    t.datetime("refreshed_at", precision: nil, null: false)
    t.index(["hr_id"], name: "index_users_on_hr_id", unique: true)
  end

  add_foreign_key "app_instances", "accounts", column: "hr_account_id", primary_key: "hr_id"
  add_foreign_key "app_instances", "catalogs", column: "hr_catalog_id", primary_key: "hr_id"
  add_foreign_key "app_instances", "customer_lists", column: "hr_customer_list_id", primary_key: "hr_id"
  add_foreign_key "app_instances", "locations", column: "hr_location_id", primary_key: "hr_id"
  add_foreign_key "user_app_instances", "app_instances", column: "hr_app_instance_id", primary_key: "hr_id"
  add_foreign_key "user_app_instances", "users", column: "hr_user_id", primary_key: "hr_id"
end
