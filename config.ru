$: << File.expand_path('./lib', File.dirname(__FILE__))

require 'rack'
require 'server'

Rack::Handler::WEBrick.run(
  Server.new,
  :Port => 9000
)
