class Bot < SlackRubyBot::Bot
  command 'restart' do |client, data, match|
    Bot.restart_counter(data.channel)
  end

  command 'counter' do |client, data, match|
    counter = IncidentFreeCounter.last.days_since_incident
    client.say(channel: data.channel, text: "The counter is currently #{counter}")
  end

  def self.restart_counter(channel)
    current_counter = IncidentFreeCounter.last.days_since_incident

    message = if current_counter > 0
                first_time(current_counter)
              else
                not_first_time
              end

    post_message(channel, message)

    IncidentFreeCounter.last.update(days_since_incident: 0)
  end

  def self.first_time(current_counter)
    sad_emojis = %w[:sad_potato: :sad_parrot: :crying_jordan_parrot: :crying_jordan: :kevin-chili:]

    image_url = get_giphy_image_link

    "~#{current_counter}~ 0 days without a fridge incident #{sad_emojis.sample} \n #{image_url}"
  end

  def self.not_first_time
    sad_emojis = %w[:sad_potato: :sad_parrot: :crying_jordan_parrot: :crying_jordan: :kevin-chili:]

    # These are "Are you serious" gifs
    image_url = %w[https://media.giphy.com/media/S7ExrA06bR3YA/giphy.gif https://media.giphy.com/media/9G3wg7lH5DpxC/giphy.gif https://media.giphy.com/media/1pAbsvGcAtwi1MwulL/giphy.gif https://media.giphy.com/media/Yi51jTwKr53ry/giphy.gif https://media.giphy.com/media/l4lRmj22EgsE3fpVm/giphy.gif].sample
    "This super intelligent bot has detected there were more than 1 fridge incident today #{sad_emojis.sample}\n#{image_url}"
  end

  def self.get_giphy_image_link
    giphy_client = GiphyClient::DefaultApi.new
    api_key = Rails.application.credentials.giphy_api_token
    tag = %w[cry mad weep].sample
    image_url = giphy_client.gifs_random_get(api_key, tag: tag).data
                            .fixed_height_downsampled_url
  end

  def self.post_message(channel, message)
    client = Slack::Web::Client.new
    client.auth_test

    client.chat_postMessage(
      channel: channel,
      text: message,
      as_user: true
    )
  end
end
