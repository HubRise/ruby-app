class HubriseApp::HrAppInstance < HubriseApp::ApplicationRecord
  self.table_name = :hr_app_instances

  belongs_to :hr_account,   optional: true
  belongs_to :hr_location,  optional: true

  def hubrise_api_client
    app.hubrise_app_gateway.build_hubrise_api_client(
      access_token:     self.hr_access_token,
      app_instance_id:  self.hr_id,
      account_id:       self.hr_account_id,
      location_id:      self.hr_location_id,
      catalog_id:       self.hr_catalog_id,
      customer_list_id: self.hr_customer_list_id
    )
  end
end
