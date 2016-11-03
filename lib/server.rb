require 'rack'

require 'board'
require 'game'
require 'html_builder'


require 'error_controller'
require 'game_play_controller'
require 'game_creation_controller'

class Server
  attr_reader :env

  def initialize
    @html = HTMLBuilder.new
    @board = Board.new
    @game_creation_controller = GameCreationController.new(self, @board, @html)

    @game_play_controller = GamePlayController.new(@game_creation_controller, @board, @html)
    @error_controller = ErrorController.new
  end

  def call(env)
    @env = env

    klass_for(path(env)).action(env)

    ['200', {'Content-Type' => 'text/html'}, [klass_for(path(env)).response]]
  end

  private

  def path(env)
    env["PATH_INFO"]
  end

  def klass_for(name)
    case name
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
