class HubriseApp::HrUserAppInstance < HubriseApp::ApplicationRecord
  self.table_name = :hr_user_app_instances

  belongs_to :hr_app_instance, primary_key: :hr_id

  REFRESH_THRESHOLD = 1.day
  def self.fresh(time: Time.now)
    where("hr_user_app_instances.refreshed_at > ?", time - REFRESH_THRESHOLD)
  end

  def refresh!(time: Time.now)
    update!(refreshed_at: time)
  end
end
