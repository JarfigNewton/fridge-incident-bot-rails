namespace :fridge_bot do
  desc "Post message to slack channel"
  task post_message: :environment do
    puts "Posting message..."
    message = "#{days_since_incident} days without a fridge incident"
    channel = "#fridge-incident-bot"
    Bot.post_message(channel, message)
    counter.update(days_since_incident: days_since_incident + 1)
    puts "Done!"
  end
end
