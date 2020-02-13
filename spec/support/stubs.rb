require 'webmock/rspec'

def stub_slack_message_api(body={})
  base_uri = Regexp.new "https://slack.com/api"
  stub_request(:any, base_uri).to_return(body: body.to_json, status: 200)
end

def stub_giphy_api
  base_uri = Regexp.new "http://api.giphy.com"
  stub_request(:any, base_uri).to_return(status: 200)
end
