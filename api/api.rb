require 'sinatra/base'
require "redis"

class MailCraftApi < Sinatra::Base
  set :bind, '0.0.0.0'

  post '/register' do
    redis = Redis.new host: "kvs"
    redis.hset(params["domain"], "email", params["email"])
    redis.hset(params["domain"], "webhook", params["webhook"])

    body = "Add record to your DNS.\n"
    body += " - MX smtp.#{params["domain"]} 10\n"
    body += " - smtp A 54.64.197.177\n"
    body += " - TXT v=spf1 ip4:54.64.197.177/32 -all\n"
    body
  end
end
