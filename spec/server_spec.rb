require 'rspec'
require 'rack/test'
require 'spec_helper'
require 'server'

RSpec.describe Server do
  include Rack::Test::Methods

  def app
    Server.new
  end

  it "The server should answer 'hello'" do
    get '/'
    expect(last_response).to be_ok
    expect(last_response.body).to eq('hello')
  end
end
