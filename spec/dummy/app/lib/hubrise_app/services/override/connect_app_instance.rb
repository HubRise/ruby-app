class HubriseApp::Services::Override::ConnectAppInstance
  def self.run(*args)
    HubriseApp::Services::ConnectAppInstance.run(*args)
  end
end
