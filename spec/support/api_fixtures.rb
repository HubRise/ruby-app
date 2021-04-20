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

    def catalog_json
      {
        "id" => "87yu4",
        "location_id" => "abc-0",
        "name" => "Some Catalog",
        "created_at" => "2000-01-01T10:00:00+02:00",
        "data" => {
          "categories" => [],
          "products" => [],
          "options_lists" => [],
          "deals" => [],
          "discounts" => [],
          "charges" => []
        }
      }
    end

    def customer_list_json
      {
        "id" => "ag8u4",
        "name" => "Some Customer List"
      }
    end

    def user_json
      {
        "first_name" => "Nick",
        "last_name" => "Save",
        "email" => "nick@save.com",
        "id" => "user_idX",
        "locales" => ["en-GB"]
      }
    end
  end
end
