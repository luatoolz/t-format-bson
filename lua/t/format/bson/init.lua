local t = require 't'
local mongo = require "mongo"
local is=t.is
local match=t.match
local pkg = t.pkg(...)

return setmetatable({
  encode=pkg.encode,
  decode=function(x, handler) if is.bson(x) then return x(handler) end; return end,
  type=mongo.type,
},{
  __index=mongo,
  __call=function(self, x) return x and self.encode(x) end,
  __mod=function(self, it) return is.bson(it) end,
  __tostring=function(self) return match.basename(t.type(self)) end,
})