require "rails_helper"

RSpec.describe EventsController do
  WebMock.disable_net_connect!(allow_localhost: true)

  it "renders challenge message" do
    # Arrange
    params = { type: "url_verification", challenge: "what does the fox say?" }

    # Act
    post :events, params

    # Assert
    expect(response).to include(params[:challenge])
  end
end
