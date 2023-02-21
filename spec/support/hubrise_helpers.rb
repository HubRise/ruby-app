module HubriseHelpers
  def stub_hr_oauth_request(code, response_body:, client_id: "dummy_id", client_secret: "dummy_secret")
    stub_request(:post, "http://dummy.hubrise.host:4003/oauth2/v1/token")
      .with(body: { client_id: client_id, client_secret: client_secret, code: code })
      .to_return(body: response_body.to_json)
  end

  def stub_hr_api_request(method, path, request_body: {}, response_body: {}, access_token: nil)
    stub_request(method, "http://dummy.hubrise.host:4000/#{path}")
      .with(
        body: request_body,
        headers: access_token ? { "X-Access-Token" => access_token } : {}
      ).to_return(body: response_body.to_json)
  end

  def post_callback_event(event_params, client_secret)
    event_hmac = OpenSSL::HMAC.hexdigest(
      OpenSSL::Digest.new("sha256"),
      client_secret,
      event_params.to_json
    )
    post(
      "/hubrise_callback/event",
      params: event_params,
      headers: { "X-Hubrise-Hmac-Sha256" => event_hmac },
      as: :json
    )
  end
end
