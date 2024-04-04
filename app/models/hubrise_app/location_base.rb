# frozen_string_literal: true
module HubriseApp
  class LocationBase < HubriseApp::ApplicationRecord
    self.abstract_class = true

    store_accessor :api_data, :name, :country

    def timezone
      api_data.dig("timezone", "name")
    end
  end
end
