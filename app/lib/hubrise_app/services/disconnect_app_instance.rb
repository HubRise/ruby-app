class HubriseApp::Services::DisconnectAppInstance
  def self.run(hr_app_instance); end
end

HubriseApp::Services::DisconnectAppInstance.include(HubriseApp::Services::Override::DisconnectAppInstance)
