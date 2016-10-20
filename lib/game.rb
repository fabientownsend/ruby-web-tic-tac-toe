require 'marks'

class Game
  attr_reader :status
  attr_reader :current_player
  attr_reader :winner

  def initialize(board)
    @board = board
    @players = [Mark::CROSS, Mark::ROUND]
    @current_player = @players.first
    @winner = ""
  end

  def play(position)
    if (is_valid?(position))
      @board.set_mark(@current_player, Integer(position))

      if (!over?)
        switch_players
      end
    end
  end

  def over?
    @board.win?(@current_player) || @board.tie?
  end

  def winner
    if (!@board.tie?)
      @winner = @current_player
    else
      @winner
    end
  end

  private

  def is_valid?(position)
    is_integer(position) && board_range?(Integer(position)) && available?(Integer(position))
  end

  def available?(position)
    @board.free_positions.include?(position)
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

  def switch_players
    @current_player = @players.reverse!.first
  end
end
