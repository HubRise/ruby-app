class HubriseApp::HrUserAppInstance < HubriseApp::ApplicationRecord
  self.table_name = :hr_user_app_instances

  belongs_to :hr_app_instance

  REFRESH_THRESHOLD = 1.day
  def self.fresh(time = Time.now)
    where('hr_user_app_instances.refreshed_at is not null and hr_user_app_instances.refreshed_at > ?', time - REFRESH_THRESHOLD)
  end
end
