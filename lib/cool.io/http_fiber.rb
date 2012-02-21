
require 'fiber'

class Coolio::HttpFiber < Coolio::Http
  def self.request opts={}
    f = Fiber.current
    super(opts){ |response|
      yield(response) if block_given?
      f.resume(response) if f.alive?
    }
    Fiber.yield
  end
end
