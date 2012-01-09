
require 'uri'
require 'cool.io'
require 'cool.io/http/payload'
require 'cool.io/http/ssl'

module Coolio
  autoload :HttpFiber, 'cool.io/http_fiber'
  autoload :SSL      , 'cool.io/http/ssl'
end

class Coolio::Http < Coolio::HttpClient
  def self.request opts={}, &block
    method  = opts[:method]  || opts['method']  || :get
    url     = opts[:url]     || opts['url']
    payload = opts[:payload] || opts['payload'] || {}
    headers = opts[:headers] || opts['headers'] || {}
    query   = opts[:query]   || opts['query']   || {}
    loop    = opts[:loop]    || opts['loop']    || Coolio::Loop.default

    uri  = URI.parse(url)
    path = if uri.path.strip.empty? then '/' else uri.path end
    q    = (uri.query || '').split('&').inject({}){ |r, i|
             k, v = i.split('=')
             r[k] = v
             r}.merge(query.inject({}){ |r, (k, v)| r[k.to_s] = v.to_s; r })
    p    = Payload.generate(payload)

    connect(uri.host, uri.port, uri.scheme.downcase == 'https').attach(loop).
      request(method.to_s.upcase, path, :query => q,
                                        :head  => p.headers.merge(headers),
                                        :body  => p.read, &block)
  end

  def self.connect host, port, ssl
    http = super(host, port)
    http.extend(Coolio::SSL) if ssl
    http
  end

  def ssl?
    false
  end

  def initialize socket
    super
    @http_data = []
  end

  def request method, path, opts={}, &block
    @http_callback = block
    super
  end

  def on_response_header response_header
    @http_response_header = response_header
  end

  def on_body_data data
    @http_data << data
  end

  def on_request_complete
    super
    @http_callback.call(@http_data.join, @http_response_header)
  end

  def on_connect
    ssl_client_start if respond_to?(:ssl_socket)
    super
  end
end
