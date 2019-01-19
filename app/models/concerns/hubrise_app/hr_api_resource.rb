module HubriseApp::HrApiResource
  REFRESH_THRESHOLD = 1.minute

  def stale?(time: Time.now)
    refreshed_at.nil? || time - refreshed_at > REFRESH_THRESHOLD
  end

  def refresh_via_api_client(api_client, time: Time.now)
    refresh(
      self.class.fetch_hr_attrs(api_client, self.hr_id),
      time: time
    )
  end

  def refresh(attrs, time: Time.now)
    update!(attrs.merge(refreshed_at: time))
  end

  module ClassMethods
    def fetch_hr_attrs(api_client, hr_id)
      raise 'Not implemented'
    end
  end
end
