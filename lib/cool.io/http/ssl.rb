
require 'openssl'

module Coolio
  module SSL
    def ssl?
      true
    end

    def ssl_socket
      @ssl_scoket ||= begin
        s = OpenSSL::SSL::SSLSocket.new(@_io, ssl_context)
        s.sync_close = true
        s
      end
    end

    def ssl_context
      @ssl_context ||= begin
        c = OpenSSL::SSL::SSLContext.new
        # c.verify_mode = OpenSSL::SSL::VERIFY_NONE
        c
      end
    end

    def ssl_completed?
      !!!@ssl_method
    end

    def ssl_client_start
      @ssl_method = :connect_nonblock
      ssl_init
    end

    def ssl_server_start
      @ssl_method = :accept_nonblock
      ssl_init
    end

    #########
    protected
    #########

    def ssl_init
      ssl_socket.__send__(@ssl_method)
      ssl_init_complete
    rescue ::IO::WaitReadable
      enable unless enabled?
    rescue ::IO::WaitWritable
      enable_write_watcher
    rescue Errno::ECONNRESET, Errno::EPIPE
      close
    rescue => e
      if respond_to?(:on_ssl_error)
        on_ssl_error(e)
      else
        raise e
      end
    end

    def ssl_init_complete
      @ssl_method = nil
      enable unless enabled?
      on_peer_cert(ssl_socket.peer_cert) if respond_to?(:on_peer_cert)
      on_ssl_connect if respond_to?(:on_ssl_connect)
    end

    def on_readable
      unless ssl_completed?
        disable
        ssl_init
        return
      end

      begin
        on_read(ssl_socket.read_nonblock(Coolio::IO::INPUT_SIZE))
      rescue Errno::EAGAIN, ::IO::WaitReadable
      rescue Errno::ECONNRESET, EOFError
        close
      end
    end

    def on_writable
      unless ssl_completed?
        # disable_write_watcher
        ssl_init
        return
      end

      begin
        nbytes = ssl_socket.write_nonblock(@_write_buffer.to_str)
      rescue Errno::EAGAIN, ::IO::WaitWritable
        return
      rescue Errno::EPIPE, Errno::ECONNRESET
        close
        return
      end

      @_write_buffer.read(nbytes)

      if @_write_buffer.empty?
        disable_write_watcher
        on_write_complete
      end
    end
  end
end
