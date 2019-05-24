module HubriseApp::HrApiResource
  REFRESH_THRESHOLD = 1.day

  def stale?
    refreshed_at.nil? || Time.now - refreshed_at > REFRESH_THRESHOLD
  end

  def refresh_via_api_client(api_client)
    return unless stale?

    refresh_with(self.class.fetch_hr_attrs(api_client, hr_id))
  end

  def refresh_with(attrs)
    update!(attrs.merge(refreshed_at: Time.now))
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
