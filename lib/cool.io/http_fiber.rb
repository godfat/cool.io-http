
require 'fiber'

class Coolio::HttpFiber < Coolio::Http
  def self.request opts={}
    f = Fiber.current
    # Thread local variables *are* fiber local variables
    # see: http://bugs.ruby-lang.org/issues/1717
    #      http://bugs.ruby-lang.org/issues/5750
    Thread.current[:coolio_http_client] = super(opts){ |response|
      yield(response) if block_given?
      f.resume(response) if f.alive?
    }
    Fiber.yield
  end
end
