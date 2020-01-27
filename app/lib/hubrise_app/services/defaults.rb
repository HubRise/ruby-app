module HubriseApp::Services::Defaults
  class NullService
    def run(*_); end
  end

  def resolve_app_instance
    HubriseApp::Services::ResolveAppInstance
  end

  def connect_app_instance
    HubriseApp::Services::ConnectAppInstance
  end

  def assign_app_instance
    HubriseApp::Services::AssignAppInstance
  end

  def disconnect_app_instance
    NullService
  end

  def handle_event
    NullService
  end
end
