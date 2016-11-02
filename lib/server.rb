require 'board'
require 'cgi'
require 'game'
require 'html_builder'
require 'rack'
require 'players_factory'
require 'game_types'

class Server
  attr_reader :env

  def initialize
    @html = HTMLBuilder.new
    @type_game = GAME_TYPES::HUMAN_VS_HUMAN
    start_new_game
  end

  def call(env)
    @env = env
    path = env["PATH_INFO"]

    if (path == "/" || path == "/reset")
      start_game
    elsif (path == "/menu")
      @type_game = parse_type_game(env)

      start_game

      @game.play if @type_game == GAME_TYPES::COMPUTER_VS_COMPUTER
    elsif (path == "/move")
      play
    end

    @html.generate_board(@board.board)
    @html.message = message(path)
    ['200', {'Content-Type' => 'text/html'}, [@html.generate_page]]
  end

  private

  def start_game
    create_game(@type_game)
    @html.game_types(@type_game)
    @game.play if @type_game == GAME_TYPES::COMPUTER_VS_COMPUTER
  end

  def create_game(type_game)
    @board = Board.new
    players = create_players(type_game)
    @game = Game.new(@board, players.player_one, players.player_two)
  end


  Players = Struct.new(:player_one, :player_two)
  def create_human_players
    Players.new(WebPlayer.new(Mark::CROSS, self), WebPlayer.new(Mark::ROUND, self))
  end

  def create_players(type_game)
    factory = PlayersFactory.new(@board, self)

    return factory.create_human_and_computer_players if (type_game == GAME_TYPES::HUMAN_VS_COMPUTER)
    return factory.create_computer_players if (type_game == GAME_TYPES::COMPUTER_VS_COMPUTER)
    return factory.create_human_players
  end

  def parse_type_game(env)
    values = CGI.parse(env["QUERY_STRING"])
    values["menu"].first
  end

  def message(path)
    return game_status if (path == "/move")
    return "Start game" if (path == "/" || path == "/reset")
    return  "Are you lost?"
  end

  def game_status
    return "Game Over - It's a tie" if (@game.over? && @game.winner.empty?)
    return "Game Over - The winner is #{@game.winner}" if (@game.over?)
    return "#{@game.current_player.mark} turn"
  end

  def play
    begin
      @game.current_player.new_move?
      @game.play
    rescue OccupiedPositionError
      @html.message = "Occupied spot"
    rescue
    end
  end
end
