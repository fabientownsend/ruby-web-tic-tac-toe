require 'cgi'

class WebPlayer
  attr_reader :mark
  attr_accessor :ready

  def initialize(mark, app)
    @app = app
    @mark = mark
    @ready = false
  end

  def next_move
    position(@app.env)
    @ready = false
    @move
  end

  def position(env)
    values = CGI.parse(env["QUERY_STRING"])
    if (@move != values["number"].first)
      @move = values["number"].first
      @ready = true
    end
  end
end

