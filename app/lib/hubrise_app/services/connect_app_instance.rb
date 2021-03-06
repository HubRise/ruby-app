class HubriseApp::Services::ConnectAppInstance
  def self.run(api_client, _ctx)
    app_instance = AppInstance.find_or_initialize_by(hr_id: api_client.app_instance_id)
    HubriseApp::Refresher::AppInstance.run(app_instance, api_client)
    app_instance
  end
end
