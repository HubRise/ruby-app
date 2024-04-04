# frozen_string_literal: true
require "rails_helper"

RSpec.describe(HubriseApp::Refresher::User) do
  let!(:today) { Date.new(2020).tap(&method(:travel_to)) }
  let(:api_client) do
    double(
      access_token: "access_tokenX",
      user_id: "user_idX"
    )
  end

  before do
    expect(api_client).to receive(:get_user).and_return(double(data: ApiFixtures.user_json))
  end

  it "creates new user" do
    user = build(:user, hr_id: "user_idX", refreshed_at: today - 10.days)

    expect do
      HubriseApp::Refresher::User.run(user, api_client)
    end.to change(User, :count).by(1)

    expect(user).to have_attributes(
      hr_id: "user_idX",
      first_name: "Nick",
      last_name: "Save",
      email: "nick@save.com",
      locales: ["en-GB"],
      access_token: "access_tokenX",
      refreshed_at: today
    )
  end

  it "refreshes existing user" do
    user = create(:user, hr_id: "user_idX", refreshed_at: today - 10.days)

    expect do
      HubriseApp::Refresher::User.run(user, api_client)
    end.to_not(change(User, :count))

    expect(user.reload).to have_attributes(
      hr_id: "user_idX",
      first_name: "Nick",
      last_name: "Save",
      email: "nick@save.com",
      locales: ["en-GB"],
      access_token: "access_tokenX",
      refreshed_at: today
    )
  end
end
