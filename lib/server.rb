require "rack"
require "board"
require "cgi"

class Server
  def initialize(board)
    @board = board
    @players = [Mark::ROUND, Mark::CROSS]
    @current_player = nil
    @message = "Start game"
  end

  def call(env)
    board = @board.board

    while !game_over
      if (env["PATH_INFO"] == "/move")
        values = CGI.parse(env["QUERY_STRING"])
        position = values["number"].first

        if is_integer(position) && available?(Integer(position)) && in_range?(Integer(position))
          @message = "#{@current_player} turn"
          switch_players
          position = Integer(position)
          @board.set_mark(@current_player, position)
        end
      end

      html = "<!doctype html><html lang=''><head><meta charset='utf-8'><title></title></head><body>
            <h1>Tic-Tac-Toe</h1><p>#{@message}</p><div id='board'>#{board.to_s}</div>
            <form action='move'><input name='number' type='number' /><input type='submit' value='Submit'/></form></body></html>"

      return ['200', {'Content-Type' => 'text/html'}, [html]]
    end

    @message = "Game Over"
    html = "<!doctype html><html lang=''><head><meta charset='utf-8'><title></title></head><body>
          <h1>Tic-Tac-Toe</h1><p>#{@message}</p><div id='board'>#{board.to_s}</div>
          <form action='move'><input name='number' type='number' /><input type='submit' value='Submit'/></form></body></html>"

    return ['200', {'Content-Type' => 'text/html'}, [html]]
  end

  private

  def switch_players
    @current_player = @players.reverse!.first
  end

  def game_over
    @board.win?(@current_player) || @board.tie?
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
