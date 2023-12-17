module HubriseApp
  module Concerns
    module Refreshable
      extend ActiveSupport::Concern

      included do
        def refresh!(api_data)
          update!(api_data: api_data, refreshed_at: Time.current)
        end
      end
    end
  end
end
