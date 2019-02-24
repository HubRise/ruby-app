class HubriseApp::Services::ConnectAppInstance
  def self.run(hr_app_instance); end
end

HubriseApp::Services::ConnectAppInstance.include(HubriseApp::Services::Override::ConnectAppInstance)
