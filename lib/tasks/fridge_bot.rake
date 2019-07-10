namespace :fridge_bot do
  desc "Post message to slack channel"
  task post_message: :environment do
    require 'slack-ruby-client'

    Slack.configure do |config|
      config.token = Rails.application.credentials.slack_api_token
      raise 'Missing ENV[SLACK_API_TOKEN]!' unless config.token
    end

    client = Slack::Web::Client.new

    client.auth_test

    counter = IncidentFreeCounter.last
    days_since_incident = counter.days_since_incident

    client.chat_postMessage(
      channel: "#fridge-incident-bot",
      text: "#{days_since_incident} days without a fridge incident",
      as_user: true
    )

    counter.update(days_since_incident: days_since_incident + 1)
  end
end
