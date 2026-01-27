# frozen_string_literal: true
module HubriseApp
  module Refresher
    class Location < Base
      class << self
        def attributes_from_api_call(resource, api_client)
          {
            api_data: cleanup_api_data(api_client.get_location(resource.hr_id).data),
          }
        end

        def attributes_from_a(event_params)
          {
            api_data: cleanup_api_data(event_params["new_state"]),
          }
        end

        private

        def cleanup_api_data(api_data)
          api_data.except("id", "account")
        end
      end
    end
  end
end
