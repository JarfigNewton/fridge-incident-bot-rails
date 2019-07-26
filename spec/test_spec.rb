class TestWebmock
  require 'httparty'

  def self.hit_endpoint_one
    array = []
    2.times do
      endpoint = "http://test.com"
      response = HTTParty.get(endpoint)
      array << response.body
    end
    array
  end

  def self.hit_endpoint_two
    array = []
    2.times do
      endpoint = "http://test.com"
      response = HTTParty.get(endpoint)
      array << response.body
    end
    array
  end
end

RSpec.describe TestWebmock do
  require 'webmock/rspec'
  WebMock.disable_net_connect!(allow_localhost: true)

  it "recreates issue with WebMock" do
    # Arrange
    endpoint = "test.com"
    stub_request(:any, endpoint).to_return(body: "1").then
                                .to_return(body: "2")

    # Act/Assert
    expect(TestWebmock.hit_endpoint_one).to eq(["1", "2"])
    expect(TestWebmock.hit_endpoint_two).to eq(["1", "2"])
  end
end
