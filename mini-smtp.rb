require 'mini-smtp-server'

class StdoutSmtpServer < MiniSmtpServer
    def new_message_event(message_hash)
        file = File.open('/tmp/smtp-log','a')
        file.puts message_hash
        file.close
    end
end

server = StdoutSmtpServer.new(25, "0.0.0.0", 4)
server.start
server.join
