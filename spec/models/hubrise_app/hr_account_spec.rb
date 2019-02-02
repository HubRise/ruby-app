require "rails_helper"

RSpec.describe HubriseApp::HrAccount do
  let(:time) { Time.new(2000) }

  describe ".refresh_or_create_via_api_client" do
    context "account level connection" do
      subject do
        stub_hr_api_request(:get, "v1/accounts/x_account_id", access_token: "x_access_token", response_body: { id: "x_account_id", name: "account1", currency: "EUR" })
        api_client = HubriseApp::HubriseGateway.build_api_client(access_token: "x_access_token", account_id: "x_account_id")

        Timecop.freeze(time) do
          described_class.refresh_or_create_via_api_client(api_client, "x_account_id")
        end
      end

      it "creates new account" do
        expect { subject }.to change(described_class, :count).by(1)
        expect(described_class.last).to have_attributes(
          hr_id: "x_account_id",
          hr_api_data: { "name" => "account1", "currency" => "EUR" },
          refreshed_at: time
        )
      end

      it "refreshes existing account" do
        hr_account = create(:hr_account, hr_id: "x_account_id")

        expect { subject }.to_not change(described_class, :count)
        expect(hr_account.reload).to have_attributes(
          hr_id: "x_account_id",
          hr_api_data: { "name" => "account1", "currency" => "EUR" },
          refreshed_at: time
        )
      end
    end

    it "creates account using location level connection" do
      stub_hr_api_request(:get, "v1/locations/x_location_id", access_token: "x_access_token", response_body: { name: "location1", account: { name: "account1", currency: "EUR" }})
      api_client = HubriseApp::HubriseGateway.build_api_client(access_token: "x_access_token", account_id: "x_account_id", location_id: "x_location_id")

      expect do
        Timecop.freeze(time) do
          described_class.refresh_or_create_via_api_client(api_client, "x_account_id")
        end
      end.to change(described_class, :count)

      expect(described_class.last).to have_attributes(
        hr_id: "x_account_id",
        hr_api_data: { "name" => "account1", "currency" => "EUR" },
        refreshed_at: time
      )
    end
  end
end
