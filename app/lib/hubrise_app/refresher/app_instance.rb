# frozen_string_literal: true
module HubriseApp
  module Refresher
    class AppInstance < Base
      class << self
        def run(resource, api_client, **refresher_args)
          resource.update!(
            access_token: api_client.access_token,
            account: HubriseApp::Refresher::Account.from_api_client(
              api_client, **refresher_args
            ),
            location: HubriseApp::Refresher::Location.from_api_client(
              api_client, **refresher_args
            ),
            catalog: HubriseApp::Refresher::Catalog.from_api_client(
              api_client, **refresher_args
            ),
            customer_list: HubriseApp::Refresher::CustomerList.from_api_client(
              api_client, **refresher_args
            )
          )
          resource
        end
      end
    end
  end
end
