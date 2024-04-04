# frozen_string_literal: true
module HubriseApp
  class CatalogBase < HubriseApp::ApplicationRecord
    self.abstract_class = true

    store_accessor :api_data, :name
  end
end
