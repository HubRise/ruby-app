require "rails_helper"

RSpec.describe HubriseApp::Refresher::Account do
  let(:time) { Time.new(2000) }

  let(:hr_account) { HubriseApp::HrAccount.new(hr_id: "x_account_id")}
  context "account level connection" do
    subject do
      stub_hr_api_request(:get, "v1/accounts/x_account_id", access_token: "x_access_token", response_body: { id: "x_account_id", name: "account1", currency: "EUR" })
      api_client = HubriseApp::HubriseGateway.new(HubriseApp::CONFIG).build_api_client(access_token: "x_access_token", account_id: "x_account_id")

      Timecop.freeze(time) do
        HubriseApp::Refresher::Account.run(hr_account, api_client)
      end
    end

    it "refreshes an account" do
      subject

      expect(hr_account).to have_attributes(
        hr_id: "x_account_id",
        hr_api_data: { "name" => "account1", "currency" => "EUR" },
        refreshed_at: time
      )
    end
  end

  context "location level connection" do
    subject do
      stub_hr_api_request(:get, "v1/locations/x_location_id", access_token: "x_access_token", response_body: { name: "location1", account: { name: "account1", currency: "EUR" } })
      api_client = HubriseApp::HubriseGateway.new(HubriseApp::CONFIG).build_api_client(access_token: "x_access_token", account_id: "x_account_id", location_id: "x_location_id")

      Timecop.freeze(time) do
        HubriseApp::Refresher::Account.run(hr_account, api_client)
      end
    end

    it "refreshes an account" do
      subject

      expect(hr_account).to have_attributes(
        hr_id: "x_account_id",
        hr_api_data: { "name" => "account1", "currency" => "EUR" },
        refreshed_at: time
      )
    end
  end
end
