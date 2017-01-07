require 'socket'
require 'logger'

port = 25

gs = TCPServer.open(port)
addr = gs.addr
addr.shift

logger = Logger.new(STDOUT)

while true
  Thread.start(gs.accept) do |socket|
    socket.puts "220 smtp server ready"

    data_flag = false

    while buffer = socket.gets
      request = buffer.upcase.chomp

      if data_flag == true
        if "." == request
          socket.puts "250 ok"
          data_flag = false
        else
          logger.debug(buffer)
        end
      else
        case request

          when 'DATA'
            data_flag = true
            socket.puts "354 ok"

          when /^RCPT TO:/
            socket.puts "250 ok"

          when 'QUIT'
            logger.debug("221")
            socket.puts "221 bye"
            s.close

          else
            logger.debug("250")
            socket.puts "250 ok"
        end
      end
    end
  end
end
