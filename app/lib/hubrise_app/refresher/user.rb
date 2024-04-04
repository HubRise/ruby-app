# frozen_string_literal: true
module HubriseApp
  module Refresher
    class User < Base
      class << self
        def fetch_attributes(_resource, api_client)
          api_data = api_client.get_user.data
          {
            access_token: api_client.access_token,
            email: api_data["email"],
            first_name: api_data["first_name"],
            last_name: api_data["last_name"],
            locales: api_data["locales"],
          }
        end
      end
    end
  end
end
