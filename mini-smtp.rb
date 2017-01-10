require 'mail'
require 'mini-smtp-server'
require './telnet-send-email.rb'

class StdoutSmtpServer < MiniSmtpServer
    def new_message_event(message_hash)
        mail = Mail.new(message_hash[:data])
        from = mail.to.first
        to = "" #TODO: fetch register email
        subject = mail.subject

        if mail.multipart?
          message = mail.parts.first.body.decoded
        else
          message = mail.body.decoded
        end

        telnet = TelnetSendEmail.new(to: to, from: from, subject: subject, message: message)
        telnet.send_email

        file = File.open('/tmp/smtp-log','a')
        file.puts message_hash
        file.close
    end
end

server = StdoutSmtpServer.new(25, "0.0.0.0", 4)
server.start
server.join
