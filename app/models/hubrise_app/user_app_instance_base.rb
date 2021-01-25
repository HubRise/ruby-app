module HubriseApp
  class UserAppInstanceBase < HubriseApp::ApplicationRecord
    self.abstract_class = true

    belongs_to :app_instance, primary_key: :hr_id, foreign_key: :hr_app_instance_id

    REFRESH_THRESHOLD = 1.day
    def self.fresh(time: Time.now)
      where("user_app_instances.refreshed_at > ?", time - REFRESH_THRESHOLD)
    end
  end
end
