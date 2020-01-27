class HubriseApp::Services::ConnectAppInstance
  def self.run(api_client, _ctx)
    hr_app_instance = HubriseApp::HrAppInstance.find_or_initialize_by(hr_id: api_client.app_instance_id)
    HubriseApp::HrAppInstance::Refresh.run(hr_app_instance, api_client)
    hr_app_instance
  end
end
