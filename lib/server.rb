require "rack"

class Server
  RESPONSE = ['200', {'Content-Type' => 'text/html'}, ['hello']]

  def call(env)
    RESPONSE
  end

  def run
    app = Proc.new do |env|
      RESPONSE
    end

    app
  end
end
