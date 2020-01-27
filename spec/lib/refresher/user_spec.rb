require "rails_helper"

RSpec.describe HubriseApp::Refresher::User do
  let(:time) { Time.new(2000) }

  subject do
    stub_hr_api_request(:get, "v1/user", access_token: "x_access_token", response_body: { first_name: "Nick", last_name: "Save", email: "nick@save.com", id: "x_user_id" })
    api_client = HubriseApp::HubriseGateway.new(HubriseApp::CONFIG).build_api_client(access_token: "x_access_token")

    Timecop.freeze(time) do
      HubriseApp::Refresher::User.run(api_client)
    end
  end

  it "creates new user" do
    expect { subject }.to change(HubriseApp::HrUser, :count).by(1)
    expect(subject).to have_attributes(
      hr_id: "x_user_id",
      hr_api_data: { "first_name" => "Nick", "last_name" => "Save", "email" => "nick@save.com" },
      hr_access_token: "x_access_token",
      refreshed_at: time
    )
  end

  it "refreshes existing user" do
    hr_user = create(:hr_user, hr_id: "x_user_id")

    expect { subject }.to_not change(HubriseApp::HrUser, :count)
    expect(hr_user.reload).to have_attributes(
      hr_id: "x_user_id",
      hr_api_data: { "first_name" => "Nick", "last_name" => "Save", "email" => "nick@save.com" },
      hr_access_token: "x_access_token",
      refreshed_at: time
    )
  end
end
