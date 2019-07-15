class Event
  def self.message_posted(channel, event_data)
    message = event_data['text']
    return unless message
    # Don't do anything if message doesn't include fridge and ajar and again
    return if message.exclude?("fridge") || message.exclude?("ajar")

    Bot.restart_counter(channel)
  end
end
