class HubriseApp::Refresher::Account
  REFRESH_THRESHOLD = 1.day

  class << self
    def run(hr_account, api_client)
      return unless stale?(hr_account)
      raise if api_client.account_id != hr_account.hr_id

      hr_account.update!(
        refreshed_at: Time.now,
        hr_api_data: if api_client.location_id
                       api_client.get_location(api_client.location_id).data["account"]
                     else
                       api_client.get_account(hr_account.hr_id).data
                     end.except("id")
      )
    end

    def stale?(hr_account)
      hr_account.refreshed_at.nil? || Time.now - hr_account.refreshed_at > REFRESH_THRESHOLD
    end
  end
end
