require "rails_helper"

RSpec.describe HubriseApp::Refresher::Location do
  let(:time) { Time.new(2000) }

  let(:location_id) { ApiFixtures.location_json["id"] }
  let(:location) { Location.new(hr_id: location_id) }
  let(:api_client) do
    HubriseApp::HubriseGateway
      .new(HubriseApp::CONFIG)
      .build_api_client(access_token: "x_access_token",
                        location_id: location_id)
  end

  subject do
    stub_hr_api_request(:get,
                        "v1/locations/#{location_id}",
                        access_token: "x_access_token",
                        response_body: ApiFixtures.location_json)

    Timecop.freeze(time) do
      HubriseApp::Refresher::Location.run(location, api_client)
    end
  end

  it "refreshes a location" do
    subject
    expect(location).to have_attributes(
      hr_id: location_id,
      api_data: a_hash_including("name" => "Some Location"),
      name: "Some Location",
      timezone: "Europe/London",
      refreshed_at: time
    )
  end
end
