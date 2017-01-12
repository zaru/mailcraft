require "./lib/smtp-server.rb"
require "./lib/telnet-send-email.rb"
require "mail"
require "net/http"
require "uri"

class MySmtpServer < SmtpServer
  def receive_message(message)
    message[:to_domain].each do |domain|

      mail = Mail.new(message[:data])
      from = mail.to.first
      subject = mail.subject
      if mail.multipart?
        message = mail.parts.first.body.decoded
      else
        message = mail.body.decoded
      end

      transfer_email = @redis.hget(domain, "email")
      if transfer_email
        telnet = TelnetSendEmail.new(to: transfer_email, from: from, subject: subject, message: message)
        telnet.send_email
      end


      webhook = @redis.hget(domain, "webhook")
      if webhook
        Net::HTTP.post_form(URI.parse(webhook),
                            {
                              subject: subject,
                              message: message
                            }
        )
      end

    end
  end
end

smtp = MySmtpServer.new port: 8888
smtp.start