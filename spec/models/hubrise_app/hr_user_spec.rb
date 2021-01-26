require "rails_helper"

RSpec.describe User do
  describe "#app_instances" do
    it "returns only fresh instances" do
      user = create(:user)
      app_instances = create_list(:app_instance, 5)
      {
        Time.new(2000) => app_instances[0],
        Time.new(2001) => app_instances[1],
        Time.new(2002, 1, 1) => app_instances[2],
        Time.new(2002, 1, 1, 12) => app_instances[3],
        Time.new(2002, 1, 2) => app_instances[4]
      }.each do |assignment_date, app_instance|
        UserAppInstance.create!(hr_user_id: user.hr_id, hr_app_instance_id: app_instance.hr_id, refreshed_at: assignment_date)
      end

      travel_to(Time.new(2002, 1, 2, 11)) do
        expect(user.app_instances.to_a).to eq(app_instances[3..4])
      end
    end
  end
end
