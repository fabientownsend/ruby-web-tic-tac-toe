require 'game_creation_controller'
require 'fake_board'

RSpec.describe GameCreationController do

  let (:board) { FakeBoard.new }
  let (:game_creation_controler) { GameCreationController.new(nil, board)}

  it "create a human vs. computer" do
    expect(game_creation_controler.action(env("human_vs_computer"))).to eq({
      :message => "Start game",
      :current_game_type => "human_vs_computer",
      :board => "board"
    })
  end

  it "create a human vs. human game" do
    expect(game_creation_controler.action(env("human_vs_human"))).to eq({
      :message => "Start game",
      :current_game_type => "human_vs_human",
      :board => "board"
    })
  end

  it "create a computer vs. computer game" do
    expect(game_creation_controler.action(env("computer_vs_computer"))).to eq({
      :message => "Game Over - It's a tie",
      :current_game_type => "computer_vs_computer",
      :board => "board"
    })
  end

  private

  def env(game_type)
{"GATEWAY_INTERFACE"=>"CGI/1.1", "PATH_INFO"=>"/menu", "QUERY_STRING"=>"menu=#{game_type}", "REMOTE_ADDR"=>"::1", "REMOTE_HOST"=>"::1", "REQUEST_METHOD"=>"GET", "REQUEST_URI"=>"http://localhost:9000/menu?menu=#{game_type}", "SCRIPT_NAME"=>"", "SERVER_NAME"=>"localhost", "SERVER_PORT"=>"9000", "SERVER_PROTOCOL"=>"HTTP/1.1", "SERVER_SOFTWARE"=>"WEBrick/1.3.1 (Ruby/2.3.1/2016-04-26)", "HTTP_HOST"=>"localhost:9000", "HTTP_CONNECTION"=>"keep-alive", "HTTP_UPGRADE_INSECURE_REQUESTS"=>"1", "HTTP_USER_AGENT"=>"Mozilla/5.0 (Macintosh; Intel Mac OS X 10_11_6) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/54.0.2840.71 Safari/537.36", "HTTP_ACCEPT"=>"text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8", "HTTP_REFERER"=>"http://localhost:9000/menu?menu=#{game_type}", "HTTP_ACCEPT_ENCODING"=>"gzip, deflate, sdch, br", "HTTP_ACCEPT_LANGUAGE"=>"en-US,en;q=0.8", "rack.version"=>[1, 3]}
  end
end
