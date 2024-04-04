# frozen_string_literal: true
module HubriseApp
  module Refresher
    class Catalog < Base
      class << self
        def fetch_attributes(resource, api_client)
          {
            api_data: api_client.get_catalog(resource.hr_id, hide_data: true)
              .data
              .except("id"),
          }
        end
      end
    end
  end
end
