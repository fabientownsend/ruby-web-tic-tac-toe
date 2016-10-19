require "rack"
require "board"
require "cgi"

class Server
  def initialize(board)
    @board = board
  end

  def call(env)
  board = @board.board

    if (env["PATH_INFO"] == "/move")
      values = CGI.parse(env["QUERY_STRING"])
      position = values["number"].first
      if is_integer(position) && available?(Integer(position)) && in_range?(Integer(position))
        position = Integer(position)
        @board.set_mark(Mark::CROSS, position)
      end
    end

    ['200', {'Content-Type' => 'text/html'}, [board.to_s]]
  end

  def available?(position)
    @board.free_positions.include?(position)
  end

  def in_range?(position)
    position >= @board.POSITION_MIN && position < @board.POSITION_MAX
  end

  def is_integer(value)
    begin
      Integer(value)
    rescue
      return false
    end
  end
end
