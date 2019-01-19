class HubriseApp::HrLocation < HubriseApp::ApplicationRecord
  self.table_name = :hr_locations

  include HubriseApp::HrApiResource
  def self.fetch_hr_attrs(api_client, hr_id)
    {
      hr_id:       hr_id,
      hr_api_data: api_client.get_location(hr_id).except('id')
    }
  end
end
