module HubriseApp
  class LocationBase < HubriseApp::ApplicationRecord
    self.abstract_class = true
    include Concerns::Refreshable

    store_accessor :api_data, :name, :country

    def timezone
      api_data.dig("timezone", "name")
    end
  end
end
