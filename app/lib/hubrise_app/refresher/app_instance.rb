class HubriseApp::Refresher::AppInstance
  class << self
    def run(hr_app_instance, api_client)
      hr_app_instance.update!(
        hr_account: build_hr_account(api_client),
        hr_location: build_hr_location(api_client),
        hr_access_token: api_client.access_token,
        hr_catalog_id: api_client.catalog_id,
        hr_customer_list_id: api_client.customer_list_id
      )
    end

    protected

    def build_hr_account(api_client)
      if api_client.account_id
        hr_account = HubriseApp::HrAccount.find_or_initialize_by(hr_id: api_client.account_id)
        HubriseApp::Refresher::Account.run(hr_account, api_client)
        hr_account
      end
    end

    def build_hr_location(api_client)
      if api_client.location_id
        hr_location = HubriseApp::HrLocation.find_or_initialize_by(hr_id: api_client.location_id)
        HubriseApp::Refresher::Location.run(hr_location, api_client)
        hr_location
      end
    end
  end
end
