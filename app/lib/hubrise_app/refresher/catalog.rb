# frozen_string_literal: true
module HubriseApp
  module Refresher
    class Catalog < Base
      class << self
        def attributes_from_api_call(resource, api_client)
          {
            api_data: cleanup_api_data(
              api_client.get_catalog(resource.hr_id, hide_data: true).data
            ),
          }
        end

        def attributes_from_event(event_params)
          {
            api_data: cleanup_api_data(event_params["new_state"]),
          }
        end

        private

        def cleanup_api_data(api_data)
          api_data.except("id")
        end
      end
    end
  end
end
