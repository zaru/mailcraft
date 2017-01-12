require 'socket'
require 'logger'

class SmtpServer

  def initialize port: 25
    @gs = TCPServer.open port
    @logger = Logger.new STDOUT
  end

  def start
    loop do
      Thread.start @gs.accept do |socket|
        socket.puts "220 smtp server ready"

        socket_line = SocketLine.new socket: socket, server: self

        while buffer = socket.gets
          request = buffer.chomp
          @logger.debug request

          response = socket_line.read request
          socket.puts response unless response.nil?
          @logger.debug response
        end
      end
    end
  end

  def receive_message(message)
  end

  class SocketLine

    def initialize socket:, server:
      @socket = socket
      @server = server
      @data_flag = false
      @from = ""
      @to = []
      @data = ""
    end

    def read request
      case request
        when /^(HELO|EHLO)/i
          return "250 #{Socket.gethostname} go on..."
        when /^QUIT/i
          @socket.close
          return ""
        when /^MAIL FROM:/i
          @from = request.gsub(/^MAIL FROM:/i, '').strip
          return "250 OK"
        when /^RCPT TO:/i
          @to << request.gsub(/^RCPT TO:/i, '').strip
          return "250 OK"
        when /^DATA/
          @data_flag = true
          return "354 Enter message, ending with \".\" on a line by itself"
      end

      if @data_flag && request =~ /^\.$/
        @data_flag = false
        @server.receive_message message
        return message
      end

      if @data_flag
        @data += "#{request}\r\n"
        return nil
      end

      "500 ERROR"
    end

    def receive_message
      yield message
    end

    def message
      {
        data: @data,
        from: @from,
        to: @to
      }
    end

  end
end

class MySmtpServer < SmtpServer
  def receive_message(message)
    p message
  end
end

smtp = MySmtpServer.new port: 8888
smtp.start