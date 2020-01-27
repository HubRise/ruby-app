module HubriseApp
  class HrAppInstance < HubriseApp::ApplicationRecord
    self.table_name = :hr_app_instances

    belongs_to :hr_account,   optional: true, primary_key: :hr_id
    belongs_to :hr_location,  optional: true, primary_key: :hr_id
  end
end
