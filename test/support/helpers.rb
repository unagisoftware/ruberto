module TestHelpers
  def stub_token_request(access_token: "foo", expires_in: 3600)
    stub_request(:post, Ruber::Authenticator::OAUTH_URL)
      .to_return(
        status: 200,
        headers: { "Content-Type" => "application/json" },
        body: {
          access_token:,
          expires_in:
        }.to_json
      )
  end
end
