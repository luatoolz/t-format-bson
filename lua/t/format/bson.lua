local t=t or require "t"
local is=t.is
local BSON = assert(require "t/patch.d/bson")
local driver = require "mongo"

return setmetatable({
  encode=BSON,
  decode=function(x, handler) if is.bson(x) then return x(handler) end; return x end,
  type=driver.type,
},{
  __call=function(self, x) return self.encode(x) end,
  __mod=function(self, it) return is.bson(it) end,
  __tostring=function(self) return t.type(self) end,
})