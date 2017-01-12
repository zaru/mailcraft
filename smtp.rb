require "./lib/smtp-server.rb"
require "./lib/telnet-send-email.rb"
require "mail"

class MySmtpServer < SmtpServer
  def receive_message(message)
    message[:to_domain].each do |domain|
      transfer_email = @redis.hget(domain, "email")

      mail = Mail.new(message[:data])
      from = mail.to.first
      subject = mail.subject

      if mail.multipart?
        message = mail.parts.first.body.decoded
      else
        message = mail.body.decoded
      end

      telnet = TelnetSendEmail.new(to: transfer_email, from: from, subject: subject, message: message)
      telnet.send_email
    end
  end
end

smtp = MySmtpServer.new
smtp.start