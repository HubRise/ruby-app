module HubriseApp
  class HrUser < HubriseApp::ApplicationRecord
    self.table_name = :hr_users

    has_many :hr_user_app_instances, -> { fresh }, primary_key: :hr_id
    has_many :hr_app_instances, through: :hr_user_app_instances

    store_accessor :hr_api_data, :first_name, :last_name, :email

    def assign_hr_app_instance(hr_app_instance)
      hr_user_app_instance = HrUserAppInstance.find_or_initialize_by(hr_app_instance_id: hr_app_instance.hr_id,
                                                                     hr_user_id: hr_id)
      hr_user_app_instance.refresh!
    end
  end
end
