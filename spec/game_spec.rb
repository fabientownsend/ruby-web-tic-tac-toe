require 'board'
require 'game'

RSpec.describe Game do
  let (:board) { Board.new }
  let (:game) { Game.new(board) }

  it "return the game status" do
    expect(game.status).to eq("Start game")
  end

  it "return the current player turn" do
    expect(game.player_turn).to eq("X turn")
  end

  it "change the player turn after a move" do
    execute_moves([0])
    expect(game.player_turn).to eq("O turn")
  end

  it "also work when then integer is a char" do
    execute_moves(["0"])
    expect(game.player_turn).to eq("O turn")
  end

  it "get back the same player after two move" do
    execute_moves([0, 1])
    expect(game.player_turn).to eq("X turn")
  end

  it "doesn't switch player when he plays an occupied position" do
    execute_moves([0, 0])
    expect(game.player_turn).to eq("O turn")
  end

  it "doesn't change the player when the value is a text" do
    game.play("asdffda")
    expect(game.player_turn).to eq("X turn")
  end

  it "doesn't change the player when the value is a under the board limit" do
    game.play(board.POSITION_MIN - 1)
    expect(game.player_turn).to eq("X turn")
  end

  it "doesn't change the player when the value is a under the board limit" do
    game.play(board.POSITION_MAX + 1)
    expect(game.player_turn).to eq("X turn")
  end

  it "return game status game over when it's a tie" do
    execute_moves([0, 1, 2, 4, 3, 6, 5, 8, 7])
    expect(game.status).to eq("Game Over")
  end

  it "return game status game over when it's a win" do
    execute_moves([0, 1, 3, 4, 6])
    expect(game.status).to eq("Game Over")
  end

  private

  def execute_moves(moves)
    moves.each { |move| game.play(move) }
  end
end
