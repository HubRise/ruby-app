class HubriseApp::HrAppInstance::Refresh
  class << self
    def run(hr_app_instance, api_client)
      hr_account  = api_client.account_id   && HubriseApp::HrAccount.refresh_or_create_via_api_client(api_client, api_client.account_id)
      hr_location = api_client.location_id  && HubriseApp::HrLocation.refresh_or_create_via_api_client(api_client, api_client.location_id)

      hr_app_instance.update!(
        hr_account: hr_account,
        hr_location: hr_location,
        hr_access_token: api_client.access_token,
        hr_catalog_id: api_client.catalog_id,
        hr_customer_list_id: api_client.customer_list_id
      )
    end
  end
end
