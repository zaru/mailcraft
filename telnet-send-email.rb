require 'net/telnet'

cmd_lists = [
"EHLO kaiha2.net",
"MAIL FROM: <zaru@kaiha2.net>",
"RCPT TO: <zarutofu@gmail.com>",
"DATA",
"Subject: hoge
From: zaru@kaiha2.net
To: zarutofu@gmail.com
hogehoge
hpipip
.",
"QUIT"
]

telnet = Net::Telnet.new("Host" => "gmail-smtp-in.l.google.com", "Port" => 25, "Timeout" => 20)

cmd_lists.each do |cmd|
  telnet.cmd({ "String" => cmd, "Match" => /^(250|354)/ }) { |c| print c }
end
