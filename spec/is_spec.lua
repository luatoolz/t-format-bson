describe("is", function()
  local t, is
  setup(function()
    t = require "t"
    is = t.is
  end)
  it("tobson", function()
    assert.is_false(is.tobson())
    assert.is_false(is.tobson(nil))
    assert.is_false(is.tobson(7))
    assert.is_false(is.tobson(""))
    assert.is_false(is.tobson({}))

    assert.is_true(is.tobson(setmetatable({}, {__tobson=function(x) return "" end})))

    assert.not_tobson()

    assert.not_tobson(setmetatable({}, {}))
    assert.not_tobson(setmetatable({}, {__call=function(x) return "" end}))

    assert.tobson(setmetatable({}, {__tobson=function(x) return "" end}))
    assert.tobson(setmetatable({}, {__toBSON=function(x) return "" end}))

    assert.tobson(t.set())
    assert.tobson(t.array())
  end)
end)
