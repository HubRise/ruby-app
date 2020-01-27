module HubriseApp::CallbackController::ActionEvent
  def event
    HubriseApp::Services.handle_event.run(current_hr_app_instance, event_params, self)
    head 200
  end
end
