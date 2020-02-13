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
    next if is_weekend? || is_holiday?
    next unless is_wednesday?
    counter = IncidentFreeCounter.last
    days_since_incident = counter.days_since_incident
    next if days_since_incident <= 0
    emoji = %w[:party_parrot: :party_ahnold: :party-starley: :ultra_fast_parrot: :shooting-starley: :spinning-potato: :party_potato: :potato-parrot:]

    giphy_client = GiphyClient::DefaultApi.new
    api_key = Rails.application.credentials.giphy_api_token
    tag = %w[happy yay hurray].sample
    image_url = giphy_client.gifs_random_get(api_key, tag: tag).data.fixed_height_downsampled_url

    message = "#{days_since_incident} #{"day".pluralize(days_since_incident.to_i)} without a fridge incident #{emoji.sample} \n #{image_url}"

    # Testing channel
    # channel = "#fridge-bot-test"

    channel = "#california-office"
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

  desc "Post monthly stats"
  task monthly_task: :environment do
    puts "Posting monthly task..."
    next if last_business_day? DateTime.now.new_offset('-08:00').to_date
    stats = Statistic.last || Statistic.create
    counter = IncidentFreeCounter.last

    if stats.monthly_high > counter.days_since_incident
      monthly_high =  stats.monthly_high
      monthly_high_date = stats.monthly_date.strftime("%m/%d/%Y")
    else
      monthly_high = counter.days_since_incident
      monthly_high_date = "TODAY! :party_ahnold:"
    end

    if stats.monthly_high > counter.days_since_incident
      all_time_high = stats.all_time_high
      all_time_high_date = stats.all_time_high_date.strftime("%m/%d/%Y")
    else
      all_time_high = counter.days_since_incident
      all_time_high_date = "TODAY! :party_ahnold:"
    end

    occurences = counter.versions.where(created_at: DateTime.now.new_offset('-08:00').beginning_of_month..DateTime.now.new_offset('-08:00').end_of_month)
    # Continue here
    occurences.map { |o| }



    message = "*## Fridge Incident Analysis:*\nOccurences: #{occurences} #{"time".pluralize(occurences)}\nMonthly high: #{monthly_high} - #{monthly_high_date}\nAll time high: #{all_time_high} - #{all_time_high_date}"
    channel = "#california-office"
    Bot.post_message(channel, message)
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

  def last_business_day?(today)
    day = DateTime.now.new_offset('-08:00').next_month.beginning_of_month
    loop do
      day = day.prev_day
      break unless day.saturday?
    end
    day.to_date == today
  end
end
