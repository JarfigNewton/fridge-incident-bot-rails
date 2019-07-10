module Bot
  class Bot < SlackRubyBot::Bot
    command 'restart' do |client, data, match|
      IncidentFreeCounter.last.update(days_since_incident: 0)
      client.say(channel: data.channel, text: "The counter has been reset to 0")
    end
  end
end
