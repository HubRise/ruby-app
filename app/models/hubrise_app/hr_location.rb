class HubriseApp::HrLocation < HubriseApp::ApplicationRecord
  self.table_name = :hr_locations

  store_accessor :hr_api_data, :name
end
