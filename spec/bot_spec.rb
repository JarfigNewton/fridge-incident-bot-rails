require "rails_helper"

RSpec.describe Bot do
  WebMock.disable_net_connect!(allow_localhost: true)

  before {
    stub_slack_message_api
  }

  let!(:counter) { create(:incident_free_counter) }

  it "restarts the counter and posts first time message" do
    # Arrange
    days_since_incident_before = counter.days_since_incident
    allow(Bot).to receive(:get_giphy_image_link).and_return("BOB")

    # Assume
    expect(Bot).to receive(:first_time)
    expect(Bot).to receive(:post_message)

    # Act
    Bot.restart_counter("ASD")

    # Assert
    expect(counter.reload.days_since_incident).to eq(0)
  end

  it "restarts the counter and posts not first time message" do
    # Arrange
    counter.update(days_since_incident: 0)
    allow(Bot).to receive(:get_giphy_image_link).and_return("BOB")

    # Assume
    expect(Bot).to receive(:not_first_time)
    expect(Bot).to receive(:post_message)

    # Act
    Bot.restart_counter("ASD")

    # Assert
    expect(counter.reload.days_since_incident).to eq(0)

  end
end
