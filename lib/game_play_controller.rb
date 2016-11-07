  class GamePlayController

    def initialize(game_creator, board)
      @game_creator = game_creator
      @game = game_creator.game
      @board = board
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

      response
    end

    private

    attr_reader :board
    attr_reader :game

    def response
      {
        :board => board.content,
        :message => game_status
      }
    end

    def game_status
      return "Game Over - It's a tie" if (game.over? && game.winner.empty?)
      return "Game Over - The winner is #{game.winner}" if (game.over?)
      return "#{game.current_player.mark} turn"
    end
  end
