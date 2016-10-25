require 'board'
require 'cgi'
require 'game'
require 'rack'
require 'html_builder'
require 'web_player'
require 'computer'

class Server
  attr_accessor :env

  def initialize(computer = false)
    @board = Board.new
    @web_player_one = WebPlayer.new(Mark::CROSS, self)
    @vs_computer = computer

    if (@vs_computer)
      @we_player_two = Computer.new(Mark::ROUND, @board)
    else
      @we_player_two = WebPlayer.new(Mark::ROUND, self)
    end

    @game = Game.new(@board, @web_player_one, @we_player_two)
  end

  def call(env)
    path = env["PATH_INFO"]
    @env = env

    if (path == "/" || path == "/reset")
      initialize(@vs_computer)
    elsif (path == "/move")
      @game.play

      if (@vs_computer)
        @game.play
      end
    end

    html = HTMLBuilder.generate_page(generate_message(path), HTMLBuilder.board(@board.board))
    ['200', {'Content-Type' => 'text/html'}, [html]]
  end

  private

  def generate_message(path)
    message = ""

    if (path == "/move")
      if (@game.over? && @game.winner.empty?)
        message += "Game Over - It's a tie"
      elsif (@game.over?)
        message += "Game Over - The winner is #{@game.winner}"
      else
        message += "#{@game.current_player.mark} turn"
      end
    elsif (path == "/" || path == "/reset")
      message += "Start game"
    else
      message += "Are you lost?"
    end

    message
  end

  def position(env)
    values = CGI.parse(env["QUERY_STRING"])
    values["number"].first
  end
end
