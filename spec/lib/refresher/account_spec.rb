require "rails_helper"

RSpec.describe HubriseApp::Refresher::Account do
  let(:time) { Time.new(2000) }

  let(:account_id) { ApiFixtures.account_json["id"] }
  let(:account) { Account.new(hr_id: account_id) }

  context "account level connection" do

    let(:api_client) do
      HubriseApp::HubriseGateway
        .new(HubriseApp::CONFIG)
        .build_api_client(access_token: "x_access_token", account_id: account_id)
    end

    subject do
      stub_hr_api_request(:get,
                          "v1/accounts/#{account_id}",
                          access_token: "x_access_token",
                          response_body: ApiFixtures.account_json)

      Timecop.freeze(time) do
        HubriseApp::Refresher::Account.run(account, api_client)
      end
    end

    it "refreshes an account" do
      subject

      expect(account).to have_attributes(
        hr_id: account_id,
        api_data: a_hash_including("name" => "Some Account", "currency" => "GBP"),
        name: "Some Account",
        currency: "GBP",
        refreshed_at: time
      )
    end
  end

  context "location level connection" do
    let(:location_id) { ApiFixtures.location_json["id"] }
    let(:api_client) do
      HubriseApp::HubriseGateway
        .new(HubriseApp::CONFIG)
        .build_api_client(
          access_token: "x_access_token",
          account_id: account_id,
          location_id: location_id
        )
    end

    subject do
      stub_hr_api_request(:get,
                          "v1/locations/#{location_id}",
                          access_token: "x_access_token",
                          response_body: ApiFixtures.location_json)

      Timecop.freeze(time) do
        HubriseApp::Refresher::Account.run(account, api_client)
      end
    end

    it "refreshes an account" do
      subject
      expect(account).to have_attributes(
        hr_id: account_id,
        api_data: a_hash_including("currency" => "GBP", "name" => "Some Account"),
        name: "Some Account",
        refreshed_at: time
      )
    end
  end
end
