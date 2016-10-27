require 'board'
require 'rack/test'
require 'rspec'
require 'server'
require 'spec_helper'
require 'web_player'

RSpec.describe Server do
  include Rack::Test::Methods

  def app
    Server.new
  end

  it "start with a new game on the default page" do
    get "/"
    expect(last_response).to be_ok
    expect(last_request.url).to eq("http://example.org/")
    expect(last_response.body).to include("Start game")
    expect(last_response.body).not_to include("X")
    expect(last_response.body).not_to include("O")
  end

  it "restart the game when the game is reset" do
    get "/reset"
    expect(last_response.body).to include("Start game")
    expect(last_response.body).not_to include("X")
    expect(last_response.body).not_to include("O")
  end

  it "display a special message when the url isn't expected" do
    get "/adsfjkla;dsf"
    expect(last_response.body).to include("Are you lost?")
  end

  it "it display the player turn when a player played" do
    get "/move?number=1"
    expect(last_request.env["PATH_INFO"]).to eq("/move")
    expect(last_response.body).to include("O turn")
    expect(last_response.body).to include("X")
  end

  it "display that the game is a tie" do
    execute_moves([0, 1, 2, 4, 3, 6, 5, 8, 7])
    expect(last_response.body).to include("Game Over")
    expect(last_response.body).to include("It's a tie")
  end

  it "display game over when a player win" do
    execute_moves([0, 1, 3, 4, 6])
    expect(last_response.body).to include("Game Over")
    expect(last_response.body).to include("The winner is X")
  end

  private

  def execute_moves(moves)
    moves.each { |move| get "/move?number=#{move}" }
  end
end
