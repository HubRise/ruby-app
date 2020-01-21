class HubriseApp::Services::Override::ResolveAppInstance
  def self.run(*args)
    HubriseApp::Services::ResolveAppInstance.run(*args)
  end
end
