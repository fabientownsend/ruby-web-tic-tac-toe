require 'rspec'
require 'rack/test'
require 'spec_helper'
require 'server'

RSpec.describe Server do
  include Rack::Test::Methods

  def app
    Server.new
  end

  it "display de default page" do
    get "/"
    expect(last_response).to be_ok
    expect(last_request.url).to eq("http://example.org/")
    expect(last_response.body).to eq("board")
  end

  it "recieve the value from the player" do
    get "/move?number=asdfas"
    expect(last_response).to be_ok
    expect(last_request.url).to eq("http://example.org/move?number=asdfas")
    expect(last_response.body).to eq("new board")
    expect(last_request.env["PATH_INFO"]).to eq("/move")
  end
end
