# frozen_string_literal: true
module HubriseApp
  module Refresher
    class Base
      REFRESH_THRESHOLD = 1.day

      class << self
        def from_api_client(api_client, **args)
          hr_id = api_client.public_send(id_key)
          if hr_id
            run(
              model_factory.find_or_initialize_by(hr_id:),
              api_client,
              **args
            )
          end
        end

        def from_event(resource, event_params, api_client)
          return if resource.nil?

          resource.update!(
            attributes_from_event(event_params, api_client).merge(
              refreshed_at: Time.now,
            )
          )
          resource
        end

        def run(resource, api_client, force: false)
          return resource if !stale?(resource) && !force

          resource.update!(
            attributes_from_api_call(resource, api_client).merge(
              refreshed_at: Time.now,
            )
          )
          resource
        end

        protected

        def attributes_from_api_call(_resource, _api_client)
          {}
        end

        def attributes_from_event(event_params, _api_client)
          event_params
        end

        def stale?(resource)
          resource.refreshed_at.nil? || Time.now - resource.refreshed_at > REFRESH_THRESHOLD
        end

        def model_factory
          const_get("::" + name.demodulize)
        end

        def id_key
          name.demodulize.underscore + "_id"
        end
      end
    end
  end
end
