class ApiFixtures
  class << self
    def account_json
      {
        "id" => "abc",
        "name" => "Some Account",
        "currency" => "GBP",
        "timezone" => {
          "name" => "Europe/London",
          "offset" => 0
        }
      }
    end

    def location_json
      {
        "id" => "abc-0",
        "name" => "Some Location",
        "account" => {
          "id" => "abc",
          "name" => "Some Account",
          "currency" => "GBP"
        },
        "address" => "",
        "postal_code" => "",
        "city" => "",
        "country" => "GB",
        "timezone" => {
          "name" => "Europe/London",
          "offset" => 0
        },
        "custom_fields" => {
        }
      }
    end
  end
end
