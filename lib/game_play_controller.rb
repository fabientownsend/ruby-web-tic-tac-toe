  class GamePlayController
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
