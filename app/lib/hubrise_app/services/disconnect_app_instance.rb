class HubriseApp::Services::DisconnectAppInstance
  prepend HubriseApp::Services::Override::DisconnectAppInstance

  class << self; delegate :run, to: :new; end
  def run(hr_app_instance); end
end
