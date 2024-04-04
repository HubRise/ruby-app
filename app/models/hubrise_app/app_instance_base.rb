# frozen_string_literal: true
module HubriseApp
  class AppInstanceBase < HubriseApp::ApplicationRecord
    self.abstract_class = true

    belongs_to :account, optional: true, primary_key: :hr_id, foreign_key: :hr_account_id
    belongs_to :location, optional: true, primary_key: :hr_id, foreign_key: :hr_location_id
    belongs_to :catalog, optional: true, primary_key: :hr_id, foreign_key: :hr_catalog_id
    belongs_to :customer_list, optional: true, primary_key: :hr_id, foreign_key: :hr_customer_list_id
  end
end
