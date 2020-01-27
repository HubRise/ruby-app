class HubriseApp::Refresher::Location
  REFRESH_THRESHOLD = 1.day

  class << self
    def run(hr_location, api_client)
      return unless stale?(hr_location)

      hr_location.update!(
        refreshed_at: Time.now,
        hr_api_data: api_client.get_location(hr_location.hr_id).data.except("id")
      )
    end

    def stale?(hr_location)
      hr_location.refreshed_at.nil? || Time.now - hr_location.refreshed_at > REFRESH_THRESHOLD
    end
  end
end
