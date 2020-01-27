class HubriseApp::Services
  class << self
    def connect_app_instance
      HubriseApp::Services::Override::ConnectAppInstance
    end

    def disconnect_app_instance
      HubriseApp::Services::Override::DisconnectAppInstance
    end

    def handle_event
      HubriseApp::Services::Override::HandleEvent
    end

    def resolve_app_instance
      HubriseApp::Services::Override::ResolveAppInstance
    end

    def assign_app_instance
      HubriseApp::Services::Override::AssignAppInstance
    end
  end
end
