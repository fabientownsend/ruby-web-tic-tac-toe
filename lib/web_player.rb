require 'cgi'

class WebPlayer
  attr_reader :mark

  def initialize(mark, app)
    @app = app
    @mark = mark
  end

  def next_move
    position(@app.env)
  end

  def position(env)
    values = CGI.parse(env["QUERY_STRING"])
    values["number"].first
  end
end

