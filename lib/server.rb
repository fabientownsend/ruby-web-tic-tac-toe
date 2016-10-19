require "rack"
require "board"
require "cgi"
require "game"

class Server
  def initialize(board)
    @board = board
    @game = Game.new(board)
  end

  def call(env)
    html = html_builder(@game.status, @board.board)

    if (env["PATH_INFO"] == "/move")
      values = CGI.parse(env["QUERY_STRING"])
      position = values["number"].first

      @game.play(position)

      if !@game.over?
        html = html_builder(@game.player_turn, @board.board)
      else
        html = html_builder(@game.status, @board.board)
      end
    end

    ['200', {'Content-Type' => 'text/html'}, [html]]
  end

  private

  def html_builder(message, board)
    "<!doctype html><html lang=''><head><meta charset='utf-8'><title></title></head><body>
    <h1>Tic-Tac-Toe</h1><p>#{message}</p><div id='board'>#{board}</div><form action='move'>
    <input name='number' type='number' /><input type='submit' value='Submit'/></form></body></html>"
  end
end
