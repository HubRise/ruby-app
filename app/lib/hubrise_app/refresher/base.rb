class HubriseApp::Refresher::Base
  REFRESH_THRESHOLD = 1.day

  class << self
    def from_api_client(api_client, *args)
      hr_id = api_client.public_send(id_key)
      if hr_id
        run(
          model_factory.find_or_initialize_by(hr_id: hr_id),
          api_client,
          *args
        )
      end
    end

    def run(resource, api_client, force: false)
      return resource if !stale?(resource) && !force

      resource.update!(
        fetch_attributes(resource, api_client).merge(
          refreshed_at: Time.now,
        )
      )
      resource
    end

    protected

    def fetch_attributes(_resource, _api_client)
      {}
    end

    def stale?(resource)
      resource.refreshed_at.nil? || Time.now - resource.refreshed_at > REFRESH_THRESHOLD
    end

    def model_factory
      const_get("::" + self.name.demodulize)
    end

    def id_key
      self.name.demodulize.underscore + "_id"
    end
  end
end
