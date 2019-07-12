class Bot < SlackRubyBot::Bot
  command 'restart' do |client, data, match|
    Bot.restart_counter(data.channel)
  end

  command 'counter' do |client, data, match|
    counter = IncidentFreeCounter.last.days_since_incident
    client.say(channel: data.channel, text: "The counter is currently #{counter}")
  end

  def self.restart_counter(channel)
    client = Slack::Web::Client.new
    client.auth_test

    current_counter = IncidentFreeCounter.last.days_since_incident
    sad_emojis = %w[:sad_potato: :sad_parrot: :crying_jordan_parrot: :crying_jordan: :kevin-chili:]

    giphy_client = GiphyClient::DefaultApi.new
    api_key = Rails.application.credentials.giphy_api_token
    tag = %w[cry scream mad weep].sample
    image_url = giphy_client.gifs_random_get(api_key, tag: tag).data.fixed_height_downsampled_url

    message = "~#{current_counter}~ 0 days without a fridge incident #{sad_emojis.sample} \n #{image_url}"

    client.chat_postMessage(channel: channel, text: message)
    IncidentFreeCounter.last.update(days_since_incident: 0)
  end

  def self.post_message(channel, message)
    client = Slack::Web::Client.new
    client.auth_test

    counter = IncidentFreeCounter.last
    days_since_incident = counter.days_since_incident

    client.chat_postMessage(
      channel: channel,
      text: message,
      as_user: true
    )
  end
end
