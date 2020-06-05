local log = ngx.log

local tmp = require "kong.plugins.hello-world.tmp"


describe("should be awesome", function()
    it("should be easy to use", function()
        assert.truthy("Yup.")
    end)

    it("should have lots of features", function()
        -- deep check comparisons!
        assert.are.same({ table = "great"}, { table = "great" })

        -- or check by reference!
        assert.are_not.equal({ table = "great"}, { table = "great"})
        assert.falsy(nil)
        local t = tmp.set_header(nil,"a")
        assert.truthy(t)
        log(ngx.ERR, "---", t)

        assert.has.error(function() error("Wat") end, "Wat")
    end)
end)