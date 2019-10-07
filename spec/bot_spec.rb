require "rails_helper"

RSpec.describe Bot do
  WebMock.disable_net_connect!(allow_localhost: true)

  before {
    stub_slack_message_api
  }

  let(:counter) { create(:incident_free_counter) }

  it "restarts the counter" do
    # Arrange
    allow(Bot).to receive(:get_giphy_image_link).and_return("BOB")

    # Act
    Bot.restart_counter("ASD")

    # Assert
    expect(counter.days_since_incident).to eq(5)
  end

  it "posts first time message" do
    # Arrange
    allow(Bot).to receive(:get_giphy_image_link).and_return("BOB")

    # Expect
    expect(Bot).to receive(:post_message).with("ASD", /0 days without a fridge incident/)

    # Act
    Bot.restart_counter("ASD")
  end

  it "posts second time message" do
    # Arrange
    counter.update(days_since_incident: 0)

    # Expect
    expect(Bot).to receive(:post_message).with("ASD", /more than 1 fridge incident today/)

    # Act
    Bot.restart_counter("ASD")
  end


end
