# frozen_string_literal: true
module HubriseApp
  module Refresher
    class Account < Base
      class << self
        def attributes_from_api_call(resource, api_client)
          {
            api_data: cleanup_api_data(
              if api_client.location_id
                api_client.get_location(api_client.location_id).data["account"]
              else
                api_client.get_account(resource.hr_id).data
              end
            ),
          }
        end

        def attributes_from_event(event_params)
          {
            api_data: cleanup_api_data(
              if event_params["resource_type"] == "location"
                event_params["new_state"]["account"]
              else
                event_params["new_state"]
              end
            ),
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
