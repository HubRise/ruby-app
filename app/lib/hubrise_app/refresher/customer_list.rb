# frozen_string_literal: true
module HubriseApp
  module Refresher
    class CustomerList < Base
      class << self
        def fetch_attributes(resource, api_client)
          {
            api_data: api_client.get_customer_list(resource.hr_id)
              .data
              .except("id"),
          }
        end
      end
    end
  end
end
