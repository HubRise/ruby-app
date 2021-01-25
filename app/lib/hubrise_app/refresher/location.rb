class HubriseApp::Refresher::Location
  REFRESH_THRESHOLD = 1.day

  class << self
    def run(location, api_client, force: false)
      if stale?(location) || force
        api_data = api_client.get_location(location.hr_id).data
        location.update!(
          refreshed_at: Time.now,
          api_data: api_data.except("id", "account")
        )
      end
    end

    def stale?(location)
      location.refreshed_at.nil? || Time.now - location.refreshed_at > REFRESH_THRESHOLD
    end
  end
end
