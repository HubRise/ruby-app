class AddApiJsonColumn < ActiveRecord::Migration[6.0]
  def change
    add_column :accounts, :api_data, :json, after: :hr_id
    add_column :locations, :api_data, :json, after: :hr_id
  end
end
