local t=t or require "t"
local is=t.is ^ "mongo"
local pkg = t.pkg(...)
local driver = require "mongo"

return setmetatable({
  encode=pkg.encode,
  decode=function(x, handler) if is.bson(x) then return x(handler) end; return end,
  type=driver.type,
},{
  __call=function(self, x) return x and self.encode(x) end,
  __mod=function(self, it) return is.bson(it) end,
  __tostring=function(self) return t.type(self) end,
})