$: << File.expand_path('./lib', File.dirname(__FILE__))

require 'rack'
require 'server'

Rack::Handler::WEBrick.run(
  Server.new(true),
  :Port => 9000
)
