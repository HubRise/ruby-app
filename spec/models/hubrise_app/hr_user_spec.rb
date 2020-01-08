require "rails_helper"

RSpec.describe HubriseApp::HrUser do
  let(:time) { Time.new(2000) }

  describe ".refresh_or_create_via_api_client" do
    subject do
      stub_hr_api_request(:get, "v1/user", access_token: "x_access_token", response_body: { first_name: "Nick", last_name: "Save", email: "nick@save.com", id: "x_user_id" })
      api_client = HubriseApp::HubriseGateway.new(HubriseApp::CONFIG).build_api_client(access_token: "x_access_token")

      Timecop.freeze(time) do
        described_class.refresh_or_create_via_api_client(api_client)
      end
    end

    it "creates new user" do
      expect { subject }.to change(described_class, :count).by(1)
      expect(described_class.last).to have_attributes(
        hr_id: "x_user_id",
        hr_api_data: { "first_name" => "Nick", "last_name" => "Save", "email" => "nick@save.com" },
        hr_access_token: "x_access_token",
        refreshed_at: time
      )
    end

    it "refreshes existing user" do
      hr_user = create(:hr_user, hr_id: "x_user_id")

      expect { subject }.to_not change(described_class, :count)
      expect(hr_user.reload).to have_attributes(
        hr_id: "x_user_id",
        hr_api_data: { "first_name" => "Nick", "last_name" => "Save", "email" => "nick@save.com" },
        hr_access_token: "x_access_token",
        refreshed_at: time
      )
    end
  end

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
        Timecop.freeze(assignment_date) { hr_user.assign_hr_app_instance(hr_app_instance) }
      end

      Timecop.freeze(Time.new(2002, 1, 2, 11)) do
        expect(hr_user.hr_app_instances.to_a).to eq(hr_app_instances[3..4])
      end
    end
  end

  it "is open for extension" do
    hr_user = create(:hr_user)
    aggregate_failures do
      expect(hr_user.foo).to eq(:foo)
      expect(hr_user.foo_app_instances).to be_kind_of(ActiveRecord::Associations::CollectionProxy)
    end
  end
end
