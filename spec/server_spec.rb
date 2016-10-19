require 'rspec'
require 'rack/test'
require 'spec_helper'
require 'server'
require 'board'
require 'board_helper'

RSpec.describe Server do
  include Rack::Test::Methods

  def app
    board = Board.new
    @helper = BoardHelper.new(board)
    Server.new(board)
  end

  it "display de default page" do
    get "/"
    expect(last_response).to be_ok
    expect(last_request.url).to eq("http://example.org/")
    expect(@helper.board_to_string).to eq("   ,   ,   ")
  end

  it "recieve the value from the player" do
    get "/move?number=1"
    expect(last_response).to be_ok
    expect(last_request.url).to eq("http://example.org/move?number=1")
    expect(last_request.env["PATH_INFO"]).to eq("/move")
    expect(@helper.board_to_string).to eq(" X ,   ,   ")
  end

  it "doesn't set a string value" do
    get "/move?number=asdfjl"
    expect(@helper.board_to_string).to eq("   ,   ,   ")
  end

  it "doesn't set the value too high" do
    get "/move?number=10"
    expect(@helper.board_to_string).to eq("   ,   ,   ")
  end

  it "doesn't set the value too low" do
    get "/move?number=-10"
    expect(@helper.board_to_string).to eq("   ,   ,   ")
  end
end
