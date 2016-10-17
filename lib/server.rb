require 'rack'

class Server
  def call(env)
    [200, {}, 'hello']
  end
end
