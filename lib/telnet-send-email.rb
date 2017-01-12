require "net/telnet"
require "resolv"


class TelnetSendEmail

  def initialize to: , from: , subject: , message:
    @to = to
    @to_domain = to.match(/@(.+)$/)[1]
    @from = from
    @from_domain = from.match(/@(.+)$/)[1]
    @subject = subject
    @message = message
  end

  def send_email
    telnet = Net::Telnet.new("Host" => fetch_mail_server, "Port" => 25, "Timeout" => 20)
    command_lists.each do |cmd|
      telnet.cmd({ "String" => cmd, "Match" => /^(250|354)/ }) { |c| print c }
    end
  end

  private

  def fetch_mail_server
    Resolv::DNS.new.getresources(@to_domain, Resolv::DNS::Resource::IN::MX).first.exchange.to_s
  end

  def command_lists
    [
      "EHLO #{@from_domain}",
      "MAIL FROM: <#{@from}>",
      "RCPT TO: <#{@to}>",
      "DATA",
      message_data,
      "QUIT"
    ]
  end

  def message_data
    <<-EOM
Subject: #{@subject}
From: #{@from}
To: #{@to}
#{@message}

.
    EOM
  end
  
end
