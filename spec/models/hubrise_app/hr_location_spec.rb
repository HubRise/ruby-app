require "rails_helper"

RSpec.describe HubriseApp::HrLocation do
  let(:time) { Time.new(2000) }

  describe ".refresh_or_create_via_api_client" do
    subject do
      stub_hr_api_request(:get, "v1/locations/x_location_id", access_token: "x_access_token", response_body: { name: "location1", account: { name: "account1", currency: "EUR" } })
      api_client = HubriseApp::HubriseGateway.new(HubriseApp::CONFIG).build_api_client(access_token: "x_access_token", account_id: "x_account_id")

      Timecop.freeze(time) do
        described_class.refresh_or_create_via_api_client(api_client, "x_location_id")
      end
    end

    it "creates new location" do
      expect { subject }.to change(described_class, :count).by(1)
      expect(described_class.last).to have_attributes(
        hr_id: "x_location_id",
        hr_api_data: { "name" => "location1", "account" => { "name" => "account1", "currency" => "EUR" } },
        refreshed_at: time
      )
    end

    it "refreshes existing location" do
      hr_location = create(:hr_location, hr_id: "x_location_id", refreshed_at: time - 1.year)

      expect { subject }.to_not change(described_class, :count)
      expect(hr_location.reload).to have_attributes(
        hr_id: "x_location_id",
        hr_api_data: { "name" => "location1", "account" => { "name" => "account1", "currency" => "EUR" } },
        refreshed_at: time
      )
    end
  end
end
