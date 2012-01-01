
require 'cool.io/http'

def request klass
  klass.request(:url => 'http://example.com'){ |response, headers|
    puts "Response: #{response}"
    puts
    puts " Headers: #{headers}"
  }
end

request(Coolio::Http)
Coolio::Loop.default.run
puts

Fiber.new{
  request(Coolio::HttpFiber)
  puts "DONE"
}.resume
puts "GO"
Coolio::Loop.default.run
