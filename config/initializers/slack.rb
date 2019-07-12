require 'slack-ruby-client'

Slack.configure do |config|
  config.token = Rails.application.credentials.slack_api_token
  raise 'Missing Rails.application.credentials.slack_api_token!' unless config.token
end
