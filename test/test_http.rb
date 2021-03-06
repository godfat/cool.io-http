
require 'bacon'
require 'cool.io/http'
require 'rack'

Bacon.summary_on_exit
port = rand(30000) + 1024

pid = Process.fork do
  $stdout.reopen(IO::NULL)
  $stderr.reopen(IO::NULL)
  Rack::Handler::WEBrick.run(
    lambda{ |env| [200, {'Content-Type' => 'test/ok'}, ['ok']] },
    :Port => port)
end
sleep(0.5)
at_exit{ Process.kill 2, pid }

module Kernel
  def eq? rhs
    self == rhs
  end
end

describe Coolio::Http do
  def request klass, url
    klass.request(:url => url){ |response| assert(response) }
  end

  def assert response
    response.body                   .should.eq 'ok'
    response.headers['CONTENT_TYPE'].should.eq 'test/ok'
    response.status                 .should.eq 200
  end

  should 'asynchrony' do
    request(Coolio::Http, "http://localhost:#{port}").
      should.kind_of?(Coolio::Http)
    Coolio::Loop.default.run
  end

  should 'synchrony' do
    Fiber.new{
      assert(request(Coolio::HttpFiber, "http://localhost:#{port}"))
    }.resume
    Coolio::Loop.default.run
  end

  should 'synchrony do not resume dead fiber' do
    f = Fiber.new{
      request(Coolio::HttpFiber, "http://localhost:#{port}")
    }
    t = Coolio::AsyncWatcher.new
    t.on_signal{ detach; f.resume }
    t.signal
    t.attach(Coolio::Loop.default)
    f.resume
    Coolio::Loop.default.run
  end

  should 'synchrony detach in the middle' do
    f = Fiber.new{
      Coolio::HttpFiber.request(:url => "http://localhost:#{port}"){ |r|
        'never reach here'.should.kind_of?(FalseClass)
      }
      Thread.current[:coolio_http_client].should.not.nil?
      Thread.current[:coolio_http_client].detach
    }
    t = Coolio::AsyncWatcher.new
    t.on_signal{ detach; f.resume }
    t.signal
    t.attach(Coolio::Loop.default)
    f.resume
    Coolio::Loop.default.run
  end

  should 'ssl' do
    sock = TCPSocket.new('localhost', port)
    Coolio::Http.new(sock)                    .ssl?.should == false
    Coolio::Http.new(sock).extend(Coolio::SSL).ssl?.should == true
  end
end
