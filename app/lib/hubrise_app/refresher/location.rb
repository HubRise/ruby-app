# frozen_string_literal: true
module HubriseApp
  module Refresher
    class Location < Base
      class << self
        def fetch_attributes(resource, api_client)
          {
            api_data: api_client.get_location(resource.hr_id)
              .data
              .except("id", "account"),
          }
        end
      end
    end
  end
end
