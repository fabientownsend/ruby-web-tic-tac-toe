class FakeGame
  attr_accessor :winner

  def initialize(args = {})
    args = defaults.merge(args)

    @winner = args[:winner]
    @is_over = args[:is_over]
    @turn = args[:turn]
    @occupied_err = args[:occupied_err]
    @out_range_err = args[:out_range_err]
    @argument_err = args[:argument_err]
  end

  def defaults
    {
      :winner => "",
      :is_over => true,
      :turn => "X",
      :occupied_err => false,
      :out_range_err => false,
      :argument_err => false
    }
  end

  def over?
    is_over
  end

  def play
    if occupied_err
      raise OccupiedPositionError
    elsif out_range_err
      raise OutOfRangeError
    elsif argument_err
      raise ArgumentError
    end
  end

  Mark = Struct.new(:mark, :update_status_move)
  def current_player
    Mark.new(turn, true)
  end

  private

  attr_accessor :is_over
  attr_accessor :turn
  attr_accessor :occupied_err
  attr_accessor :out_range_err
  attr_accessor :argument_err

end
