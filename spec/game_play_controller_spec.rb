require 'game_play_controller'
require 'fake_game'
require 'fake_board'

RSpec.describe GamePlayController do
  let (:board) { FakeBoard.new }

  it "return the board and that it is a tie when game over and no winner" do
    play_controller = GamePlayController.new(FakeGame.new, board)

    expect(play_controller.action(nil)).to eq({
      :board => "board",
      :message => "Game Over - It's a tie"
    })
  end

  it "return the board and winner when game over by a win" do
    winner = "X"
    play_controller = GamePlayController.new(FakeGame.new({:winner => winner}), board)

    expect(play_controller.action(nil)).to eq({
      :board => "board",
      :message => "Game Over - The winner is #{winner}"
    })
  end

  it "return the board and the current player when the game isn't over" do
    play_controller = GamePlayController.new(FakeGame.new({:is_over => false}), board)

    expect(play_controller.action(nil)).to eq({
      :board => "board",
      :message => "X turn"
    })
  end

  it "handle OccupiedPositionError and return the board anyway" do
    play_controller = GamePlayController.new(FakeGame.new({
      :is_over => false,
      :occupied_err => true}), board)

    expect(play_controller.action(nil)).to eq({
      :board => "board",
      :message => "X turn"
    })
  end

  it "handle OutOfRangeError and return the board anyway" do
    play_controller = GamePlayController.new(FakeGame.new({
      :is_over => false,
      :out_range_err => true}), board)

    expect(play_controller.action(nil)).to eq({
      :board => "board",
      :message => "X turn"
    })
  end

  it "handle ArgumentError and return the board anyway" do
    play_controller = GamePlayController.new(FakeGame.new({
      :is_over => false,
      :argument_err => true}), board)

    expect(play_controller.action(nil)).to eq({
      :board => "board",
      :message => "X turn"
    })
  end
end
