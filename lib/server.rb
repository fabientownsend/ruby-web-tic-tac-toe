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
      GameCreationController
    when '/reset'
      @board = Board.new
      GameCreationController
    when '/menu'
      @board = Board.new
      GameCreationController
    when '/move'
      GamePlayController
    else
      ErrorController
    end
  end
end
