local cjson    = require "cjson"
local helpers  = require "spec.helpers"


for _, strategy in helpers.each_strategy() do
  describe("Plugin: hello-world [#" .. strategy .. "]", function()
    local proxy_client
    -- , proxy_ssl_client
    --local proxy_client_grpc, proxy_client_grpcs
    --ngx.sleep(10)
    lazy_setup(function()
      local bp = helpers.get_db_utils(strategy, {
        "plugins",
        "routes",
        "services",
      })

      local route = bp.routes:insert {
        hosts = { "hello-world.com" },
      }

      --local route = bp.routes:insert {
      --  hosts = { "hello-world.com" },
      --}

      bp.plugins:insert {
        route = { id = route.id },  -- 改为nil表示 apply globally
        name     = "hello-world",
        config   = {
          --say_hello = True
        },
      }

      assert(helpers.start_kong({
        database   = strategy,
        plugins = "hello-world",  -- 启用插件
        lua_package_path = "./kong/plugins/hello-world/?.lua", -- 配置插件路径
        nginx_conf = "spec/fixtures/custom_nginx.template",
      }))

      proxy_client = helpers.proxy_client()
      --proxy_ssl_client = helpers.proxy_ssl_client()
      --proxy_client_grpc = helpers.proxy_client_grpc()
      --proxy_client_grpcs = helpers.proxy_client_grpcs()
    end)

    lazy_teardown(function()
      if proxy_client then
        proxy_client:close()
      end

      helpers.stop_kong()
    end)

    it("test hello-world", function()
        local res = assert( proxy_client:send {
          method  = "GET",
          path    = "/status/200",
          headers = {
            host = "hello-world.com"
          }
        })

        assert.response(res).has.status(403)
        local body = cjson.decode(assert.res_status(403, res))

        if next(body) == nil then
          ngx.log(ngx.ERR, "nil")
        else
          ngx.log(ngx.ERR, "----->","non-nil")
        end
        print("-----------------------------")
        helpers.pprint(body)
        print("-----------------------------")
        --ngx.sleep(3*60)
        --assert.equal("admin", body.headers["x-authenticated-groups"])
        --assert.equal(nil, body.headers["x-consumer-groups"])
      end)
    end)
  break -- 去掉Cassandra测试
end
