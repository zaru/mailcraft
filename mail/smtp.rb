require "./lib/smtp-server.rb"
require "./lib/telnet-send-email.rb"
require "./lib/mail_ignite.rb"
require "mail"
require "net/http"
require "uri"

class MySmtpServer < SmtpServer
  def receive_message(message)
    message[:to_domain].each do |domain|
      mail_ignite = MailIgnite.new(domain domain, data: message[:data])
      mail_ignite.transfer_email
      mail_ignite.request_webhook
    end
  end
end

smtp = MySmtpServer.new port: 25
smtp.start