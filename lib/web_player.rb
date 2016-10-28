require 'cgi'

class WebPlayer
  attr_reader :mark
  attr_accessor :ready

  def initialize(mark, app)
    @app = app
    @mark = mark
    @ready = true
  end

  def next_move
    position(@app.env)
  end

  def position(env)
    values = CGI.parse(env["QUERY_STRING"])
    values["number"].first
  end
end

