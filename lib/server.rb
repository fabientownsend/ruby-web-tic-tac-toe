require 'rack'

require 'board'
require 'error_controller'
require 'game'
require 'game_creation_controller'
require 'game_play_controller'
require 'html_builder'

class Server
  attr_reader :env

  def initialize
    @html = HTMLBuilder.new
    @board = Board.new
    @game_creation_controller = GameCreationController.new(self, @board)
    @game_play_controller = GamePlayController.new(@game_creation_controller, @board)
    @error_controller = ErrorController.new
  end

  def call(env)
    @env = env

    response = controller_for(path).action(env)

    ['200', {'Content-Type' => 'text/html'}, [@html.create(response)]]
  end

  private

  def path
    env["PATH_INFO"]
  end

  def controller_for(path)
    case path
    when '/'
      @game_creation_controller
    when '/reset'
      @game_creation_controller
    when '/menu'
      @game_creation_controller
    when '/move'
      @game_play_controller
    else
      @error_controller
    end
  end
end
