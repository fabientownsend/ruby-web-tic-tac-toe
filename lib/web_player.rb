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
    @ready = false
    get_move
  end

  def new_move?
    @ready = true if @move != get_move
  end

  def get_move
    values = CGI.parse(@app.env["QUERY_STRING"])
    values["number"].first
  end
end

