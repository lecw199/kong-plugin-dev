local BasePlugin = require "kong.plugins.base_plugin"
-- local access = require "kong.plugins.hello-world.access"

local HelloWorldHandler = BasePlugin:extend()
local FORBIDDEN = 403

HelloWorldHandler.PRIORITY = 2000

function HelloWorldHandler:new()
  HelloWorldHandler.super.new(self, "hello-world")
end


function HelloWorldHandler:access(conf)
  HelloWorldHandler.super.access(self)
  local headers = {}
  if conf.say_hello then
    ngx.log(ngx.ERR, "============ Hello World! ============")
    ngx.header["Hello-World"] = "Hello World!!!"
  else
    ngx.log(ngx.ERR, "============ Bye World! ============")
    ngx.header["Hello-World"] = "Bye World!!!"
  end
  local data = {}
  data["info"] = "forbiden"
  --headers["aaa"] = "#######"
  --kong.ctx.plugin.headers = headers
  --kong.response.add_header("aaa", "#####")
  kong.response.exit(403, data, nil)
end

function HelloWorldHandler:header_filter(_)
  local headers = kong.ctx.plugin.headers
  if headers then
    kong.response.set_headers(headers)
  end
end

return HelloWorldHandler


