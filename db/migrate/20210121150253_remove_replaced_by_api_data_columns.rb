class RemoveReplacedByApiDataColumns < ActiveRecord::Migration[6.0]
  def change
    remove_column :accounts, :name
    remove_column :accounts, :currency

    remove_column :locations, :name
    remove_column :locations, :timezone
  end
end
