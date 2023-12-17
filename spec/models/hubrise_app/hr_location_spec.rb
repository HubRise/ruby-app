require "rails_helper"

RSpec.describe Location do
  let!(:location) { create(:location) }

  describe "#refresh!" do
    subject do
      location.refresh!(
        ApiFixtures.location_json.merge(
          "name" => "New name"
        )
      )
    end

    it "updates location from Hubrise" do
      expect { subject }
        .to change { JSON.parse(location.reload.api_data)["name"] }.from("Some Location").to("New name")
        .and(change { location.reload.refreshed_at })
    end
  end
end
