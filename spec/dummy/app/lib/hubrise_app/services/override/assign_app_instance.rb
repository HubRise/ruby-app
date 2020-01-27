class HubriseApp::Services::Override::AssignAppInstance
  def self.run(*args)
    HubriseApp::Services::AssignAppInstance.run(*args)
  end
end
