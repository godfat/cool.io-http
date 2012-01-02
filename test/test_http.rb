
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
