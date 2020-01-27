module HubriseApp::CallbackController::ActionDisconnect
  def disconnect
    HubriseApp::Services.disconnect_app_instance.run(current_hr_app_instance, self)
    head 200
  end
end
