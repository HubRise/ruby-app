# frozen_string_literal: true
module HubriseApp
  module Refresher
    class Catalog < Base
      class << self
        def attributes_from_api_call(resource, api_client)
          {
            api_data: fetch_api_data(resource.hr_id, api_client),
          }
        end

        def attributes_from_event(event_params, api_client)
          {
            api_data:
              # Catalog update events do not contain "new_state", so we need to fetch from the API
              fetch_api_data(event_params["id"], api_client),
          }
        end

        private

        def fetch_api_data(catalog_id, api_client)
          api_client.get_catalog(catalog_id, hide_data: true).data.except("id")
        end
      end
    end
  end
end
