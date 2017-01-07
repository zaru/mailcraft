require 'mini-smtp-server'

class StdoutSmtpServer < MiniSmtpServer
    def new_message_event(message_hash)
        p message_hash
    end
end

server = StdoutSmtpServer.new(25, "0.0.0.0", 4)
server.start
server.join
