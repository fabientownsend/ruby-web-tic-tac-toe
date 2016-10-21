require 'board'
require 'cgi'
require 'game'
require 'rack'
require 'html_builder'

class Server
  def initialize
    start_new_game
  end

  def call(env)
    if (env["PATH_INFO"] == "/" || env["PATH_INFO"] == "/reset")
      start_new_game
      html = HTMLBuilder.generate_page("Start game", HTMLBuilder.board(@board.board))
    elsif (env["PATH_INFO"] == "/move")
      @game.play(position(env))

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
      message += "#{@game.current_player} turn"
    end

    message
  end

  def start_new_game
    @board = Board.new
    @game = Game.new(@board)
  end

  def position(env)
    values = CGI.parse(env["QUERY_STRING"])
    values["number"].first
  end
end
