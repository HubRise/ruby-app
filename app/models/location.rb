class Location < HubriseApp::ApplicationRecord
  store_accessor :api_data, :name

  def timezone
    api_data.dig("timezone", "name")
  end
end
