  class GamePlayController

    def initialize(game_creator, board, html)
      @game_creator = game_creator
      @game = game_creator.game
      @board = board
      @html = html
    end

    def action(env)
      @game = @game_creator.game

      begin
        @game.current_player.new_move?
        @game.play
      rescue OccupiedPositionError
      rescue OutOfRangeError
      rescue
      end
    end

    def response
      html.generate_board(board.content)
      html.message = game_status
      html.generate_page
    end

    private

    attr_accessor :html
    attr_reader :board
    attr_reader :game

    def game_status
      return "Game Over - It's a tie" if (game.over? && game.winner.empty?)
      return "Game Over - The winner is #{game.winner}" if (game.over?)
      return "#{game.current_player.mark} turn"
    end
  end
