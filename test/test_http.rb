
require 'cool.io/http'

def request klass, url
  klass.request(:url => url){ |response, headers|
    puts "Response: #{response}"
    puts
    puts " Headers: #{headers}"
  }
end

request(Coolio::Http, 'http://google.com')
Coolio::Loop.default.run
puts

Fiber.new{
  request(Coolio::HttpFiber, 'https://google.com')
  puts "DONE"
}.resume
puts "GO"
Coolio::Loop.default.run

describe 'ssl' do
  should 'respect ssl?' do
    port = rand(30000) + 1024
    serv = TCPServer.new('localhost', port)
    sock = TCPSocket.new('localhost', port)
    Coolio::Http.new(sock)                    .ssl?.should == false
    Coolio::Http.new(sock).extend(Coolio::SSL).ssl?.should == true
    serv.close
  end
end
