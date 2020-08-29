class AddLocationsTimezone < ActiveRecord::Migration[6.0]
  def change
    add_column :locations, :timezone, :string, null: false, default: Time.zone.name
  end
end
