class Game
  attr_reader :status
  attr_reader :player_turn

  def initialize(board)
    @board = board
    @status = "Start game"
    @players = [Mark::CROSS, Mark::ROUND]
    @current_player = @players.first
    @player_turn = "X turn"
  end

  def play(position)
    if (is_integer(position) && board_range?(Integer(position)) && available?(Integer(position)))
      @board.set_mark(@current_player, Integer(position))

      if (over?)
        @status = "Game Over"
      else
        switch_players
      end
    end
  end

  def over?
    @board.win?(@current_player) || @board.tie?
  end

  private

  def valid_position?(position)
  end

  def available?(position)
    @board.free_positions.include?(position)
  end

  def switch_players
    @current_player = @players.reverse!.first
    @player_turn = "#{@current_player} turn"
  end

  def is_integer(value)
    begin
      Integer(value)
    rescue
      return false
    end
  end

  def board_range?(position)
    position >= @board.POSITION_MIN && position <= @board.POSITION_MAX
  end
end
