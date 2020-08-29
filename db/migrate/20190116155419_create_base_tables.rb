class CreateBaseTables < ActiveRecord::Migration[5.2]
  def change
    create_table :accounts do |t|
      t.string :hr_id, null: false, index: { unique: true }
      t.string :name, null: false
      t.string :currency, null: false
      t.datetime :refreshed_at, null: false
    end

    create_table :locations do |t|
      t.string :hr_id, null: false, index: { unique: true }
      t.string :name, null: false
      t.datetime :refreshed_at, null: false
    end

    create_table :app_instances do |t|
      t.string :hr_id, null: false, index: { unique: true }
      t.string :hr_account_id, index: true
      t.string :hr_location_id, index: true
      t.string :hr_catalog_id
      t.string :hr_customer_list_id
      t.string :access_token, null: false
    end

    add_foreign_key :app_instances, :accounts, primary_key: :hr_id, column: :hr_account_id
    add_foreign_key :app_instances, :locations, primary_key: :hr_id, column: :hr_location_id

    create_table :users do |t|
      t.string :hr_id, null: false, index: { unique: true }
      t.string :access_token, null: false
      t.string :email
      t.string :first_name
      t.string :last_name
      t.string :locales, array: true
      t.datetime :refreshed_at, null: false
    end

    create_table :user_app_instances do |t|
      t.string :hr_user_id, index: true
      t.string :hr_app_instance_id, index: true
      t.datetime :refreshed_at, null: false
    end

    add_foreign_key :user_app_instances, :users, primary_key: :hr_id, column: :hr_user_id
    add_foreign_key :user_app_instances, :app_instances, primary_key: :hr_id, column: :hr_app_instance_id
    add_index :user_app_instances, %i[hr_user_id hr_app_instance_id refreshed_at], name: :index_user_app_instances, using: :btree
  end
end
