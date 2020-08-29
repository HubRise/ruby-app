class HubriseApp::Refresher::AppInstance
  class << self
    def run(app_instance, api_client)
      app_instance.update!(
        account: build_account(api_client),
        location: build_location(api_client),
        access_token: api_client.access_token,
        hr_catalog_id: api_client.catalog_id,
        hr_customer_list_id: api_client.customer_list_id
      )
    end

    protected

    def build_account(api_client)
      if api_client.account_id
        account = Account.find_or_initialize_by(hr_id: api_client.account_id)
        HubriseApp::Refresher::Account.run(account, api_client)
        account
      end
    end

    def build_location(api_client)
      if api_client.location_id
        location = Location.find_or_initialize_by(hr_id: api_client.location_id)
        HubriseApp::Refresher::Location.run(location, api_client)
        location
      end
    end
  end
end
