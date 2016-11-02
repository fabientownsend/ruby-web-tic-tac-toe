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
  end

  def call(env)
    @env = env
    path = env["PATH_INFO"]

    my_klass = klass_for(path).new(@board, self, @game, @html)
    @game = my_klass.action(env)
    @result = my_klass.response

    ['200', {'Content-Type' => 'text/html'}, [@result]]
  end

  private

  def klass_for(name)
    case name
    when '/'
      @board = Board.new
      GameCreation
    when '/reset'
      @board = Board.new
      GameCreation
    when '/menu'
      @board = Board.new
      GameCreation
    when '/move'
      GamePlay
    else
      Error
    end
  end

  class GameCreation
    require 'html_builder'
    require 'board'
    require 'players_factory'

    def initialize(board, event, useless, html)
      @html = html
      @type_game = ""
      @board = board
      @event = event
    end

    def action(env)
      @type_game = parse_type_game(env)

      create_game(@type_game)
      @game.play if @type_game == GAME_TYPES::COMPUTER_VS_COMPUTER
      return @game
    end

    def response
      @html.game_types(@type_game) if @type_game != nil
      @html.generate_board(@board.content)
      @html.message = "Start game"
      @html.message = game_status if @type_game == GAME_TYPES::COMPUTER_VS_COMPUTER
      @html.generate_page
    end

    private

    def game_status
      return "Game Over - It's a tie" if (@game.over? && @game.winner.empty?)
      return "Game Over - The winner is #{@game.winner}" if (@game.over?)
      return "#{@game.current_player.mark} turn"
    end

    def parse_type_game(env)
      values = CGI.parse(env["QUERY_STRING"])
      values["menu"].first
    end

    def create_game(type_game)
      players = create_players(type_game)
      @game = Game.new(@board, players.player_one, players.player_two)
    end

    def create_players(type_game)
      factory = PlayersFactory.new(@board, @event)

      return factory.create_human_and_computer_players if (type_game == GAME_TYPES::HUMAN_VS_COMPUTER)
      return factory.create_computer_players if (type_game == GAME_TYPES::COMPUTER_VS_COMPUTER)
      return factory.create_human_players
    end
  end

  class GamePlay
    require 'html_builder'

    def initialize(board, useless, game, html)
      @board = board
      @game = game
      @html = html
    end

    def action(env)
      @game.current_player.new_move?
      @game.play
      return @game
    end

    def response
      @html.generate_board(@board.content)
      @html.message = game_status
      @html.generate_page
    end

    private

    def game_status
      return "Game Over - It's a tie" if (@game.over? && @game.winner.empty?)
      return "Game Over - The winner is #{@game.winner}" if (@game.over?)
      return "#{@game.current_player.mark} turn"
    end
  end

  class Error
    def initialize(one, two, three, html)
      @game = three
    end

    def action(env)
      @game
    end

    def response
      "error 404"
    end
  end
end
