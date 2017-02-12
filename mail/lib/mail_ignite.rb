class MailIgnite

  def initialize domain:, data:
    @redis = Redis.new host: "kvs"
    @domain = domain

    mail = Mail.new(data)
    @from = mail.to.first
    @subject = mail.subject
    if mail.multipart?
      @message = mail.parts.first.body.decoded
    else
      @message = mail.body.decoded
    end
  end

  def transfer_email
    transfer_email = @redis.hget(@domain, "email")
    if transfer_email
      #TODO: fix the dependency
      telnet = TelnetSendEmail.new(to: transfer_email, from: @from, subject: @subject, message: @message)
      telnet.send_email
    end
  end

  def request_webhook
    webhook = @redis.hget(@domain, "webhook")
    if webhook
      Net::HTTP.post_form(URI.parse(webhook),
                          {
                            subject: @subject,
                            message: @message
                          }
      )
    end
  end

end