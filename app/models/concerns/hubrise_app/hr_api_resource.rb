module HubriseApp::HrApiResource
  REFRESH_THRESHOLD = 1.minute

  def stale?(time: Time.now)
    refreshed_at.nil? || time - refreshed_at > REFRESH_THRESHOLD
  end

  def refresh_via_api_client(api_client, time: Time.now)
    refresh_with(
      self.class.fetch_hr_attrs(api_client, self.hr_id),
      time: time
    )
  end

  def refresh_with(attrs, time: Time.now)
    update!(attrs.merge(refreshed_at: time))
  end

  def self.included(base)
    base.extend(ClassMethods)
  end

  module ClassMethods
    def refresh_or_create_via_api_client(api_client, hr_id)
      hr_record = find_or_initialize_by(hr_id: hr_id)
      hr_record.refresh_via_api_client(api_client)
      hr_record
    end
  end
end
