namespace :fridge_bot do
  desc "Post message to slack channel"
  task post_message: :environment do
    counter = IncidentFreeCounter.last
    days_since_incident = counter.days_since_incident
    Bot.instance.client.chat_postMessage(
      channel: "#fridge-incident-bot",
      text: "#{days_since_incident}",
      as_user: true
    )
    counter.update(days_since_incident: days_since_incident + 1)
  end
end
