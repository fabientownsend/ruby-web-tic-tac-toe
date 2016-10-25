require 'board'
require 'cgi'
require 'game'
require 'rack'
require 'html_builder'
require 'web_player'

class Server
  def initialize
    @board = Board.new
    @web_player_one = WebPlayer.new(Mark::CROSS)
    @we_player_two = WebPlayer.new(Mark::ROUND)
    @game = Game.new(@board, @web_player_one, @we_player_two)
  end

  def call(env)
    if (env["PATH_INFO"] == "/" || env["PATH_INFO"] == "/reset")
      initialize
      html = HTMLBuilder.generate_page("Start game", HTMLBuilder.board(@board.board))
    elsif (env["PATH_INFO"] == "/move")

      @web_player_one.next_move = position(env)
      @we_player_two.next_move = position(env)

      @game.play

     html = HTMLBuilder.generate_page(generate_message, HTMLBuilder.board(@board.board))
    else
        html = HTMLBuilder.generate_page("Are you lost?", HTMLBuilder.board(@board.board))
    end

    ['200', {'Content-Type' => 'text/html'}, [html]]
  end

  private

  def generate_message
    message = ""

    if (@game.over? && @game.winner.empty?)
      message += "Game Over - It's a tie"
    elsif (@game.over?)
      message += "Game Over - The winner is #{@game.winner}"
    else
      message += "#{@game.current_player.mark} turn"
    end

    message
  end

  def position(env)
    values = CGI.parse(env["QUERY_STRING"])
    values["number"].first
  end
end
