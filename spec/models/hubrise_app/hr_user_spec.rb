require "rails_helper"

RSpec.describe HubriseApp::HrUser do
  let(:time) { Time.new(2000) }

  describe "#hr_app_instances" do
    it "returns only fresh instances" do
      hr_user = create(:hr_user)
      hr_app_instances = create_list(:hr_app_instance, 5)
      {
        Time.new(2000) => hr_app_instances[0],
        Time.new(2001) => hr_app_instances[1],
        Time.new(2002, 1, 1) => hr_app_instances[2],
        Time.new(2002, 1, 1, 12) => hr_app_instances[3],
        Time.new(2002, 1, 2) => hr_app_instances[4]
      }.each do |assignment_date, hr_app_instance|
        HubriseApp::HrUserAppInstance.create!(hr_user_id: hr_user.hr_id, hr_app_instance_id: hr_app_instance.hr_id, refreshed_at: assignment_date)
      end

      Timecop.freeze(Time.new(2002, 1, 2, 11)) do
        expect(hr_user.hr_app_instances.to_a).to eq(hr_app_instances[3..4])
      end
    end
  end
end
