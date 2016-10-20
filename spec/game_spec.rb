require 'board'
require 'game'
require 'marks'

RSpec.describe Game do
  let (:board) { Board.new }
  let (:game) { Game.new(board) }
  let(:board_helper) { BoardHelper.new(board) }

  it "return the current player" do
    expect(game.current_player).to eq(Mark::CROSS)
  end

  it "return the current player after the first player played" do
    game.play(0)
    expect(game.current_player).to eq(Mark::ROUND)
    expect(board_helper.board_to_string).to eq("X  ,   ,   ")
  end

  it "work with an Integer as char" do
    game.play("0")
    expect(game.current_player).to eq(Mark::ROUND)
    expect(board_helper.board_to_string).to eq("X  ,   ,   ")
  end

  it "get back the first player after the second one played" do
    execute_moves([0, 1])
    expect(game.current_player).to eq(Mark::CROSS)
    expect(board_helper.board_to_string).to eq("XO ,   ,   ")
  end

  it "doesn't switch player when the move isn't available" do
    execute_moves([0, 0])
    expect(game.current_player).to eq(Mark::ROUND)
    expect(board_helper.board_to_string).to eq("X  ,   ,   ")
  end

  it "doesn't change the player when the move is text" do
    game.play("asdffda")
    expect(game.current_player).to eq(Mark::CROSS)
    expect(board_helper.board_to_string).to eq("   ,   ,   ")
  end

  it "doesn't change the player when the value is a under the board limit" do
    game.play(board.POSITION_MIN - 1)
    expect(game.current_player).to eq(Mark::CROSS)
    expect(board_helper.board_to_string).to eq("   ,   ,   ")
  end

  it "doesn't change the player when the value is a under the board limit" do
    game.play(board.POSITION_MAX + 1)
    expect(game.current_player).to eq(Mark::CROSS)
    expect(board_helper.board_to_string).to eq("   ,   ,   ")
  end

  it "return the game status" do
    expect(game.over?).to be false
  end

  it "return game status game over when it's a tie" do
    board_helper.string_to_board("XOX,XOX,OXO")
    expect(game.over?).to be true
  end

  it "return game status game over when it's a win" do
    board_helper.string_to_board("XO ,XO ,X  ")
    expect(game.over?).to be true
  end

  it "doesn't have a winner when it's a tie" do
    board_helper.string_to_board("XOX,XOX,OXO")
    expect(game.winner.empty?).to be true
  end

  it "return the winner when a player won" do
    board_helper.string_to_board("XO ,XO ,X  ")
    expect(game.winner.empty?).to be false
    expect(game.winner).to eq(Mark::CROSS)
  end

  private

  def execute_moves(moves)
    moves.each { |move| game.play(move) }
  end
end
