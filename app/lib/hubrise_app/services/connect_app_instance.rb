class HubriseApp::Services::ConnectAppInstance
  prepend HubriseApp::Services::Override::ConnectAppInstance

  class << self; delegate :run, to: :new; end
  def run(hr_app_instance); end
end
