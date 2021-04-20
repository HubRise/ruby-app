module HubriseApp::Refresher
  class Catalog < Base
    class << self
      def fetch_attributes(resource, api_client)
        {
          api_data: api_client.get_catalog(resource.hr_id)
                              .data
                              .except("data", "id")
        }
      end
    end
  end
end
