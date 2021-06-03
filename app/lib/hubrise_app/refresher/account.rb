module HubriseApp::Refresher
  class Account < Base
    class << self
      def fetch_attributes(resource, api_client)
        {
          api_data: if api_client.location_id
                      api_client.get_location(api_client.location_id).data["account"]
                    else
                      api_client.get_account(resource.hr_id).data
                    end.except("id")
        }
      end
    end
  end
end
