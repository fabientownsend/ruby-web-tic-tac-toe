require 'rspec'
require 'rack/test'
require 'spec_helper'
require 'server'
require 'board'
require 'board_helper'

RSpec.describe Server do
  include Rack::Test::Methods

  def app
    Server.new
  end

  it "display de default page" do
    get "/"
    expect(last_response).to be_ok
    expect(last_request.url).to eq("http://example.org/")
  end

  it "recieve the value from the player" do
    get "/move?number=1"
    expect(last_response).to be_ok
    expect(last_request.url).to eq("http://example.org/move?number=1")
    expect(last_request.env["PATH_INFO"]).to eq("/move")
  end

  it "display that the game is a tie" do
    execute_moves([0, 1, 2, 4, 3, 6, 5, 8, 7])
    expect(last_response.body).to include("Game Over")
  end

  it "display game over when a player win" do
    execute_moves([0, 1, 3, 4, 6])
    expect(last_response.body).to include("Game Over")
  end

  private

  def execute_moves(moves)
    moves.each { |move| get "/move?number=#{move}" }
  end
end
