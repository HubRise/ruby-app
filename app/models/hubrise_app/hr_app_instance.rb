module HubriseApp
  class HrAppInstance < HubriseApp::ApplicationRecord
    self.table_name = :hr_app_instances

    belongs_to :hr_account,   optional: true, primary_key: :hr_id
    belongs_to :hr_location,  optional: true, primary_key: :hr_id

    def self.refresh_or_create_via_api_client(api_client)
      hr_app_instance = find_or_initialize_by(hr_id: api_client.app_instance_id)
      hr_account      = api_client.account_id   && HrAccount.refresh_or_create_via_api_client(api_client, api_client.account_id) # rubocop:disable Metrics/LineLength
      hr_location     = api_client.location_id  && HrLocation.refresh_or_create_via_api_client(api_client, api_client.location_id) # rubocop:disable Metrics/LineLength

      hr_app_instance.update!(
        hr_account: hr_account,
        hr_location: hr_location,
        hr_access_token: api_client.access_token,
        hr_catalog_id: api_client.catalog_id,
        hr_customer_list_id: api_client.customer_list_id
      )

      hr_app_instance
    end
  end
end
