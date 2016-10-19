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

  it "display the starting message" do
    get "/"
    expect(last_response.body).to include("Start game")
  end

  it "display the correct message for the current player" do
    get "/move?number=1"
    expect(last_response.body).to include("O turn")
    get "/move?number=2"
    expect(@helper.board_to_string).to eq(" XO,   ,   ")
  end

  it "display that the game is a tie" do
    get "/move?number=0"
    get "/move?number=1"
    get "/move?number=2"
    get "/move?number=4"
    get "/move?number=3"
    get "/move?number=6"
    get "/move?number=5"
    get "/move?number=8"
    get "/move?number=7"
    expect(last_response.body).to include("Game Over")
  end

  it "display game over when a player win" do
    get "/move?number=0"
    get "/move?number=1"
    get "/move?number=3"
    get "/move?number=4"
    get "/move?number=6"
    expect(last_response.body).to include("Game Over")
  end
end
