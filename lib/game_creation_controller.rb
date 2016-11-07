require 'cgi'
require 'game'
require 'game_types'
require 'players_factory'

class GameCreationController

  attr_reader :game

  def initialize(event, board)
    @event = event
    @board = board
    @type_game = GAME_TYPES::HUMAN_VS_HUMAN
    @current_status = "Start game"

    create_game(@type_game)
  end

  def action(env)
    board.reset
    @type_game = parse_type_game(env) if parse_type_game(env) != nil
    create_game(@type_game)

    if @type_game == GAME_TYPES::COMPUTER_VS_COMPUTER
      @game.play
      @current_status = game_status
    end

    response
  end

  private

  attr_reader :event
  attr_accessor :board
  attr_accessor :current_status

  def response
    {
      :message => current_status,
      :current_game_type => @type_game,
      :board => board.content
    }
  end


  def game_status
    return "Game Over - It's a tie" if (game.over? && game.winner.empty?)
    return "Game Over - The winner is #{game.winner}" if (game.over?)
    return "#{game.current_player.mark} turn"
  end

  def parse_type_game(env)
    values = CGI.parse(env["QUERY_STRING"])
    values["menu"].first
  end

  def create_game(type_game)
    players = create_players(type_game)
    @game = Game.new(
      :board => board,
      :player_one => players.player_one,
      :player_two => players.player_two)
  end

  def create_players(type_game)
    factory = PlayersFactory.new(board, event)

    return factory.create_human_and_computer_players if (type_game == GAME_TYPES::HUMAN_VS_COMPUTER)
    return factory.create_computer_players if (type_game == GAME_TYPES::COMPUTER_VS_COMPUTER)
    return factory.create_human_players
  end
end
