module HubriseApp
  class CatalogBase < HubriseApp::ApplicationRecord
    self.abstract_class = true
    include Concerns::Refreshable

    store_accessor :api_data, :name
  end
end
