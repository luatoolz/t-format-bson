local t=t or require "t"
local export=t.exporter
local driver = require "mongo"
local add=function(x) return export(x, true) end
local clear=function(x) return export(x, false) end
local getmetatable = debug and debug.getmetatable or getmetatable

local object = driver.BSON({})
local mt = assert(getmetatable(object))

local __value = mt.value
assert(type(mt.value)=='function')
mt.value = function(self, handler) return clear(__value(self, handler)) end
mt.__call = function(self, handler) return self:value(handler) end
mt.__export = function(self) return self:value() end

local __bson=driver.BSON
driver.BSON=function(self) if self then return __bson(add(self)) end end
return driver.BSON