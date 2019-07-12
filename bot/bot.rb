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
    client.chat_postMessage(channel: channel,
                            text: "The counter has been reset from #{current_counter} to 0")
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
