class Bot < SlackRubyBot::Bot
  command 'restart' do |client, data, match|
    IncidentFreeCounter.last.update(days_since_incident: 0)
    client.say(channel: data.channel, text: "The counter has been reset to 0")
  end

  command 'counter' do |client, data, match|
    counter = IncidentFreeCounter.last.days_since_incident
    client.say(channel: data.channel, text: "The counter is currently #{counter}")
  end
end
