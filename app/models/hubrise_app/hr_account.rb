class HubriseApp::HrAccount < HubriseApp::ApplicationRecord
  self.table_name = :hr_accounts

  store_accessor :hr_api_data, :name
end
