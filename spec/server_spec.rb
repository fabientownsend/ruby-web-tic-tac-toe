require 'rspec'
require 'rack/test'
require 'spec_helper'

describe 'the app' do
  include Rack::Test::Methods

  def app
    Rack::Builder.new do
      map '/' do
        run Proc.new {|env| [200, {'Content-Type' => 'text/html'}, 'foo'] }
      end
    end
  end

  it "say foo" do
    get '/'
    last_response.should be_ok
    last_response.body.should == 'foo'
  end
end
