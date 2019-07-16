namespace :fridge_bot do
  # From: https://www.standard.com/individual/retirement/stock-market-and-bank-holidays
  # These names should match the definitions in the Holidays module we are using:
  # https://github.com/holidays/holidays/blob/master/lib/generated_definitions/us.rb#L13
  STOCK_MARKET_HOLIDAYS = ["New Year's Day", "Martin Luther King, Jr. Day", "Presidents' Day",
                           "Good Friday", "Memorial Day", "Independence Day",
                           "Labor Day", "Thanksgiving", "Christmas Day"].freeze

  desc "Post message to slack channel"
  task post_message: :environment do
    puts "Posting message..."
    # Only post on Wednesday
    # next if is_weekend? || is_holiday?
    # next unless is_wednesday?
    counter = IncidentFreeCounter.last
    days_since_incident = counter.days_since_incident
    emoji = %w[:party_parrot: :party_ahnold: :party-starley: :ultra_fast_parrot: :shooting-starley: :spinning-potato: :party_potato: :potato-parrot:]
    message = "#{days_since_incident} days without a fridge incident #{emoji.sample}"
    # channel = "#california-office"
    channel = "#fridge-bot-test"
    Bot.post_message(channel, message)
    puts "Done!"
  end

  desc "Increase counter"
  task increase_counter: :environment do
    puts "Increasing counter..."
    next if is_weekend? || is_holiday?
    counter = IncidentFreeCounter.last
    days_since_incident = counter.days_since_incident
    counter.update(days_since_incident: days_since_incident + 1)
    puts "Done!"
  end

  def is_weekend?
    today = DateTime.now.new_offset('-08:00').to_date
    today.saturday? || today.sunday?
  end

  def is_holiday?
    date =  DateTime.now.new_offset('-08:00').to_date
    holidays_on_date = Holidays.on(date).map { |day| day[:name] }
    holidays_on_date.any? { |day| STOCK_MARKET_HOLIDAYS.include?(day) }
  end

  def is_wednesday?
    today = DateTime.now.new_offset('-08:00').to_date
    today.saturday? || today.wednesday?
  end
end
