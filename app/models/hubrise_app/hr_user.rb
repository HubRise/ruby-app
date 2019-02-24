module HubriseApp
  class HrUser < HubriseApp::ApplicationRecord
    self.table_name = :hr_users

    has_many :hr_user_app_instances, ->{ fresh }, primary_key: :hr_id
    has_many :hr_app_instances, through: :hr_user_app_instances

    include HubriseApp::HrApiResource
    class << self
      def fetch_hr_attrs(api_client)
        data = api_client.get_user.data
        {
          hr_id:           data.delete('id'),
          hr_api_data:     data,
          hr_access_token: api_client.access_token
        }
      end

      def refresh_or_create_via_api_client(api_client)
        hr_attrs  = fetch_hr_attrs(api_client)
        hr_user   = find_or_initialize_by(hr_id: hr_attrs[:hr_id])
        hr_user.refresh_with(hr_attrs)
        hr_user
      end
    end

    def assign_hr_app_instance(hr_app_instance)
      hr_user_app_instance = HrUserAppInstance.find_or_initialize_by(hr_app_instance_id: hr_app_instance.hr_id, hr_user_id: hr_id)
      hr_user_app_instance.refresh!
    end
  end
end

HubriseApp::HrUser.include(HubriseApp::Override::HrUser)
