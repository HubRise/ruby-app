require "rails_helper"

RSpec.describe HubriseApp::Refresher::Location do
  let(:time) { Time.new(2000) }
  let(:location) { Location.new(hr_id: "x_location_id") }

  subject do
    stub_hr_api_request(:get, "v1/locations/x_location_id", access_token: "x_access_token", response_body: { name: "location1", account: { name: "account1", currency: "EUR" } })
    api_client = HubriseApp::HubriseGateway.new(HubriseApp::CONFIG).build_api_client(access_token: "x_access_token", account_id: "x_account_id")

    Timecop.freeze(time) do
      HubriseApp::Refresher::Location.run(location, api_client)
    end
  end

  it "refreshes a location" do
    subject
    expect(location).to have_attributes(
      hr_id: "x_location_id",
      api_data: { "name" => "location1", "account" => { "name" => "account1", "currency" => "EUR" } },
      refreshed_at: time
    )
  end
end
