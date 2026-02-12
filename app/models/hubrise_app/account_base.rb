# frozen_string_literal: true
module HubriseApp
  class AccountBase < HubriseApp::ApplicationRecord
    self.abstract_class = true
    include Concerns::Refreshable

    store_accessor :api_data, :name, :currency
  end
end
