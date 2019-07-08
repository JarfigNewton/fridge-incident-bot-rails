class Bot < SlackRubyBot::Bot

  command 'restart' do |client, data, match|
    # Fix this
    client.say(channel: data.channel, text: eval(match["expression"]))
  end
end
