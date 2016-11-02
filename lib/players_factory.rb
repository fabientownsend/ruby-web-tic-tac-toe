require 'web_player'
require 'computer'
require 'game_types'

class PlayersFactory
  def initialize(board, user_input)
    @user_input = user_input
    @board = board
  end

  Players = Struct.new(:player_one, :player_two)
  def create_human_players
    Players.new(create_human(Mark::CROSS), create_human(Mark::ROUND))
  end

  def create_human_and_computer_players
    Players.new(create_human(Mark::CROSS), create_computer(Mark::ROUND))
  end

  def create_computer_players
    Players.new(create_computer(Mark::CROSS), create_computer(Mark::ROUND))
  end

  private

  def create_human(mark)
    WebPlayer.new(mark, @user_input)
  end

  def create_computer(mark)
    Computer.new(mark, @board)
  end
end
