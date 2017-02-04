require "webrick"
require "redis"

srv = WEBrick::HTTPServer.new({
                                DocumentRoot:   "./",
                                BindAddress:    "0.0.0.0",
                                Port:           3000,
                              })

srv.mount_proc "/register" do |req, res|
  params = {}
  body = req.body.split("&")
  body.each do |line|
    key, val = line.split("&")
    params[key] = val
  end

  redis = Redis.new host: "kvs"
  redis.hset(params["domain"], "email", params["email"])
  redis.hset(params["domain"], "webhook", params["webhook"])

  res.body = "Add record to your DNS.\n"
  res.body += " - MX smtp.#{params["domain"]} 10\n"
  res.body += " - smtp A 54.64.197.177\n"
  res.body += " - TXT v=spf1 ip4:54.64.197.177/32 -all\n"

end

srv.start

