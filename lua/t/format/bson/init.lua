local t=t or require "t"
local driver = require "mongo"
local is=t.is ^ "mongo"
local match=t.match
local pkg = t.pkg(...)

return setmetatable({
  encode=pkg.encode,
  decode=function(x, handler) if is.bson(x) then return x(handler) end; return end,
  type=driver.type,
},{
  __call=function(self, x) return x and self.encode(x) end,
  __mod=function(self, it) return is.bson(it) end,
  __tostring=function(self) return match.basename(t.type(self)) end,
})