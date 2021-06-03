class AddCatalogsAndCustomerLists < ActiveRecord::Migration[6.0]
  def change
    create_table :catalogs do |t|
      t.string :hr_id, null: false
      t.json :api_data
      t.datetime :refreshed_at, null: false
      t.index :hr_id, unique: true
    end

    create_table :customer_lists do |t|
      t.string :hr_id, null: false
      t.json :api_data
      t.datetime :refreshed_at, null: false
      t.index :hr_id, unique: true
    end

    AppInstance.distinct.pluck(:hr_catalog_id).each do |hr_catalog_id|
      Catalog.create!(hr_id: hr_catalog_id, refreshed_at: Date.new(2000)) if hr_catalog_id.present?
    end

    AppInstance.distinct.pluck(:hr_customer_list_id).each do |hr_customer_list_id|
      CustomerList.create!(hr_id: hr_customer_list_id, refreshed_at: Date.new(2000)) if hr_customer_list_id.present?
    end

    add_foreign_key :app_instances, :catalogs, primary_key: :hr_id, column: :hr_catalog_id
    add_foreign_key :app_instances, :customer_lists, primary_key: :hr_id, column: :hr_customer_list_id
  end
end
