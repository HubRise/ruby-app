# frozen_string_literal: true
module HubriseApp
  module Services
    class ConnectAppInstance
      def self.run(api_client, _ctx)
        HubriseApp::Refresher::AppInstance.from_api_client(api_client)
      end
    end
  end
end
