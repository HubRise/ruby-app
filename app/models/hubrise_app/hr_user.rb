module HubriseApp
  class HrUser < HubriseApp::ApplicationRecord
    self.table_name = :hr_users

    has_many :hr_user_app_instances, -> { fresh }, primary_key: :hr_id
    has_many :hr_app_instances, through: :hr_user_app_instances

    store_accessor :hr_api_data, :first_name, :last_name, :email
  end
end
