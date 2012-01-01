
require 'fiber'

class Coolio::HttpFiber < Coolio::Http
  def self.request opts={}
    f = Fiber.current
    super(opts){ |response, headers|
      yield(response, headers)
      f.resume
    }
    Fiber.yield
  end
end
