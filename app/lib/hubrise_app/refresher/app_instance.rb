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

        def from_event(resource, event_params)
          case event_params["resource_type"]
          when "account"
            HubriseApp::Refresher::Account.from_event(resource.account, event_params)
          when "location"
            HubriseApp::Refresher::Location.from_event(resource.location, event_params)
            HubriseApp::Refresher::Account.from_event(resource.account, event_params)
          when "catalog"
            HubriseApp::Refresher::Catalog.from_event(resource.catalog, event_params)
          when "customer_list"
            HubriseApp::Refresher::CustomerList.from_event(resource.customer_list, event_params)
          end
        end

        def default_callback_events(app_instance)
          events = {}

          if app_instance.location
            events[:location] = [:update]
          end

          if app_instance.catalog
            events[:catalog] = [:update]
          end

          if app_instance.customer_list
            events[:customer_list] = [:update]
          end

          events
        end
      end
    end
  end
end
