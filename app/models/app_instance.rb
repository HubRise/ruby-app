class AppInstance < HubriseApp::ApplicationRecord
  belongs_to :account,   optional: true, primary_key: :hr_id, foreign_key: :hr_account_id
  belongs_to :location,  optional: true, primary_key: :hr_id, foreign_key: :hr_location_id
end
