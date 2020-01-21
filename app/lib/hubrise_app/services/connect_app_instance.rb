class HubriseApp::Services::ConnectAppInstance
  def self.run(api_client, _ctx)
    HubriseApp::HrAppInstance.refresh_or_create_via_api_client(api_client)
  end
end
