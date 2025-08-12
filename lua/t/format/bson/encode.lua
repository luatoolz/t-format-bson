require 'meta'
local mongo = require "mongo"
local object = mongo.BSON({})
local mt = getmetatable(object)

if not mt.__export then
  local t=require 't'
  local export=t.exporter
  local add=function(x) return export(x, true) end
  local clear=function(x) return export(x, false) end

  local __value = mt.value
  assert(type(mt.value)=='function', "no BSON.mt.value")
  mt.value = function(self, handler) return clear(__value(self, handler)) end
  mt.__call = function(self, handler) return self:value(handler) end
  mt.__export = function(self) return self:value() end

  local __bson=mongo.BSON
  mongo.BSON=function(self)
    assert(self, "mongo.BSON: nil argument");
    if type(self)=='table' then self=add(self) end
    return self and __bson(self)
  end
end

return mongo.BSON