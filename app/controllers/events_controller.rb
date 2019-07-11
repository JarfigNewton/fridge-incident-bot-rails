class EventsController < ApplicationController
  skip_before_action :verify_authenticity_token, only: [:handle]

  def handle
    # Extract the event payload from the request and parse the JSON
    request_data = JSON.parse(request.body.read)

    case request_data['type']
    when 'event_callback'
      # Get the Team ID and event data from the request object
      team_id = request_data['team_id']
      event_data = request_data['event']

      # Events have a "type" attribute included in their payload, allowing you to handle
      # different event payloads as needed.
      case event_data['type']
      when 'url_verification'
        # When we receive a `url_verification` event, we need to
        # return the same `challenge` value sent to us from Slack
        # to confirm our server's authenticity.
        request_data['challenge']
      # when 'message'
      #   # Event handler for when a user posts a message
      #   Events.user_join(team_id, event_data)
      # else
      #   # In the event we receive an event we didn't expect, we'll log it and move on.
      #   puts "Unexpected event:\n"
      #   puts JSON.pretty_generate(request_data)
      end
      # Return HTTP status code 200 so Slack knows we've received the event
      status 200
    end
    respond_to do |format|
      format.json { render :json => { "challenge": request_data['challenge'] } }
    end
  end
end
