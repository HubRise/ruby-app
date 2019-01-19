class CreateBaseTables < ActiveRecord::Migration[5.2]
  def change
    create_table :hr_accounts do |t|
      t.string   :hr_id,        null: false, index: { unique: true }
      t.json     :hr_api_data,  null: false
      t.datetime :refreshed_at, null: false
    end

    create_table :hr_locations do |t|
      t.string   :hr_id,        null: false, index: { unique: true }
      t.json     :hr_api_data,  null: false
      t.datetime :refreshed_at, null: false
    end

    create_table :hr_app_instances do |t|
      t.string :hr_id, null: false, index: { unique: true }
      t.string :hr_account_id,  index: true
      t.string :hr_location_id, index: true
      t.string :hr_catalog_id
      t.string :hr_customer_list_id
      t.string :hr_access_token, null: false
    end

    add_foreign_key :hr_app_instances, :hr_accounts, primary_key: :hr_id
    add_foreign_key :hr_app_instances, :hr_locations, primary_key: :hr_id

    create_table :hr_users do |t|
      t.string   :hr_id,            null: false, index: { unique: true }
      t.json     :hr_api_data,      null: false
      t.string   :hr_access_token,  null: false
      t.datetime :refreshed_at,     null: false
    end
  
    create_table :hr_user_app_instances do |t|
      t.string    :hr_user_id,         index: true
      t.string    :hr_app_instance_id, index: true
      t.datetime  :refreshed_at, null: false
    end

    add_foreign_key :hr_user_app_instances, :hr_users, primary_key: :hr_id
    add_foreign_key :hr_user_app_instances, :hr_app_instances, primary_key: :hr_id
    add_index :hr_user_app_instances, [:hr_user_id, :hr_app_instance_id, :refreshed_at], name: :index_user_app_instances, using: :btree
  end
end
