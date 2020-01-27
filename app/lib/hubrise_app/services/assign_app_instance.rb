class HubriseApp::Services::AssignAppInstance
  def self.run(hr_user, hr_app_instance, _ctx)
    HubriseApp::HrUserAppInstance.find_or_initialize_by(
      hr_app_instance_id: hr_app_instance.hr_id,
      hr_user_id: hr_user.hr_id
    ).update!(refreshed_at: Time.now)
  end
end
