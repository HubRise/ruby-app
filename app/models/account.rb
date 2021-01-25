class Account < HubriseApp::ApplicationRecord
  store_accessor :api_data, :name, :currency
end
