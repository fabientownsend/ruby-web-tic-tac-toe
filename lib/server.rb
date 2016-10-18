require "rack"
require "cgi"

class Server
  def call(env)
  board = "board"
    if (env["PATH_INFO"] == "/move")
      values = CGI.parse(env["QUERY_STRING"])
      puts values["number"]
      board = "new board"
    end

    ['200', {'Content-Type' => 'text/html'}, [board]]
  end
end
