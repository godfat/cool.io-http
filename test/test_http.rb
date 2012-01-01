
require 'cool.io/http'

Coolio::Http.request(:url => 'http://example.com'){ |response, headers|
  puts "Response: #{response}"
  puts
  puts " Headers: #{headers}"
}

Coolio::Loop.default.run
