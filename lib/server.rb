require 'board'
require 'cgi'
require 'computer'
require 'game'
require 'html_builder'
require 'rack'
require 'web_player'

class Server
  attr_reader :env

  def initialize(computer = false)
    @board = Board.new
    @web_player_one = WebPlayer.new(Mark::CROSS, self)
    @vs_computer = computer

    if (@vs_computer)
      @web_player_two = Computer.new(Mark::ROUND, @board)
    else
      @web_player_two = WebPlayer.new(Mark::ROUND, self)
    end

    @game = Game.new(@board, @web_player_one, @web_player_two)
  end

  def call(env)
    @env = env

    path = env["PATH_INFO"]

    if (path == "/" || path == "/reset")
      initialize(@vs_computer)
    elsif (path == "/move")
      play
    end

    html = HTMLBuilder.generate_page(generate_message(path), HTMLBuilder.board(@board.board))
    ['200', {'Content-Type' => 'text/html'}, [html]]
  end

  private

  def generate_message(path)
    message = ""

    if (path == "/move")
      message += message_move
    elsif (path == "/" || path == "/reset")
      message += "Start game"
    else
      message += "Are you lost?"
    end

    message
  end

  def message_move
    if (@game.over? && @game.winner.empty?)
      "Game Over - It's a tie"
    elsif (@game.over?)
      "Game Over - The winner is #{@game.winner}"
    else
      "#{@game.current_player.mark} turn"
    end
  end

  def play
    begin
      @game.current_player.new_move?
      @game.play
    rescue
    end
  end
end
