require "meta"
local t=t or require "t"
local tex=t.exporter
local driver = require "mongo"

local getmetatable = debug.getmetatable or getmetatable
local setmetatable = debug.setmetatable or setmetatable

local function add(self)
  if type(self)~='table' or getmetatable(self) then return self end
  if type(self[1])~='nil' then self.__array=true end
  local rv={}
  for k,v in pairs(self) do rv[k]=add(v) end
  return rv
end

local function clear(self)
  if type(self)~='table' then return self end
  setmetatable(self, nil)
  self.__array=nil
  for k,v in pairs(self) do clear(v) end
  return self
end

local function is_mongo(x)
  return type(x)=='userdata' and (driver.type(x) or ''):startswith('mongo.')
end

local object = driver.BSON({})
if type(object)~='nil' then
  local mt = getmetatable(object)
  assert(type(mt)=='table')
  local __value = mt.value
  assert(type(mt.value)=='function')
  mt.value = function(self, handler) return clear(__value(self, handler)) end
  mt.__call = function(self, handler) return self:value(handler) end

  local __bson=driver.BSON
  driver.BSON=function(self) return __bson(add(self)) end
end

return setmetatable({
  null=driver.Null,
  encode=function(x) return driver.BSON(x) end,
  decode=function(x, handler) if is_mongo(x) then return clear(x:value(handler)) end end,
  type=driver.type,
  mongo=is_mongo,
},{
  __call=function(self, x, skip)
    if rawequal(self.null, x) or type(x)=='nil' then return self.null end
--    if is.string(x) then return assert(self.encode(x)) end
--    if is.atom(x) then return x end
--    if is.atom(x) then return assert(self.encode(x)) end
    return assert(self.encode(tex(x, true)))
  end,
})
