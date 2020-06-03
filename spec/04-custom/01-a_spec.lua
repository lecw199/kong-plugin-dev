local log = ngx.log

describe("should be awesome", function()
  it("should be easy to use", function()
    assert.truthy("Yup.")
  end)

  it("should have lots of features", function()
    -- deep check comparisons!
    assert.are.same({ table = "great"}, { table = "great" })

    -- or check by reference!
    assert.are_not.equal({ table = "great"}, { table = "great"})
    log(ngx.ERR, "---", "----")

    assert.True(1 < 2)
    assert.falsy(nil)
    assert.has.error(function() error("Wat") end, "Wat")
  end)
end)

