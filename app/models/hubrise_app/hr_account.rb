class HubriseApp::HrAccount < HubriseApp::ApplicationRecord
  self.table_name = :hr_accounts

  include HubriseApp::HrApiResource
  class << self
    def fetch_hr_attrs(api_client, hr_id)
      raise if api_client.account_id != hr_id

      {
        hr_id:        hr_id,
        hr_api_data:  if api_client.location_id
                        api_client.get_location(api_client.location_id).data['account']
                      else
                        api_client.get_account(hr_id).data
                      end.except("id")
      }
    end
  end
end
