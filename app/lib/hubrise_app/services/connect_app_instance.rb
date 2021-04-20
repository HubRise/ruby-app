class HubriseApp::Services::ConnectAppInstance
  def self.run(api_client, _ctx)
    HubriseApp::Refresher::AppInstance.from_api_client(api_client)
  end
end
