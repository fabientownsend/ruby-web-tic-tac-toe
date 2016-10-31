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
    @html = HTMLBuilder.new
  end

  def call(env)
    @env = env

    path = env["PATH_INFO"]

    if (path == "/" || path == "/reset")
      initialize(@vs_computer)
      @html.game_types("human_vs_human")
    elsif (path == "/menu")
      values = CGI.parse(env["QUERY_STRING"])
      type_game = values["menu"].first

      if (type_game == "human_vs_human")
        initialize(false)
        @html.game_types("human_vs_human")
      elsif (type_game == "human_vs_computer")
        initialize(true)
        @html.game_types("human_vs_computer")
      elsif (type_game == "computer_vs_computer")
        initialize(true)
        @html.game_types("computer_vs_computer")
      end
    elsif (path == "/move")
      play
    end

    @html.message = generate_message(path)
    @html.the_test(@board.board)
    ['200', {'Content-Type' => 'text/html'}, [@html.generate_page]]
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
