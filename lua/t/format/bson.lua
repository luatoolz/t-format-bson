local driver = require "mongo"
require "meta"

local getmetatable = debug.getmetatable or getmetatable
local setmetatable = debug.setmetatable or setmetatable

local atom = {
  ["number"]=true,
  ["boolean"]=true,
  ["string"]=true,
}

local function clear(self)
  if type(self)~='table' then return self end
  setmetatable(self, nil)
  self.__array=nil
  for k,v in pairs(self) do clear(v) end
  return self
end

local function __bson(x)
  local mt = getmetatable(x or {}) or {}
  local to = mt.__toBSON or mt.__tobson
  if type(to)=='function' then return to(x) end
end

local function is_mongo(x)
  return type(x)=='userdata' and (driver.type(x) or ''):startswith('mongo.')
end

return setmetatable({
  null=driver.Null,
  encode=function(x) return driver.BSON(x) end,
  decode=function(x) if is_mongo(x) then return clear(x:value()) end end,
  type=driver.type,
  mongo=is_mongo,
},{
  __call=function(self, x)
    if type(x)=='function' or type(x)=='thread' or type(x)=='CFunction' then x=tostring(x) end
    if atom[type(x)] then return x end
    if x==self.null or type(x)=='nil' then return self.null end
    if self.mongo(x) then return x end
    if type(x)=='userdata' then
      local mt = getmetatable(x or {}) or {}
      local to = mt.__toBSON or mt.__tobson
      if type(to)=='function' then
        return __bson(x)
      end
      return tostring(x)
    end
    if type(x)=='table' then
      if not getmetatable(x) then return self.encode(x) end
      local mt = getmetatable(x or {}) or {}
      local to = mt.__toBSON or mt.__tobson
      if type(to)=='function' then
        return self.encode(__bson(x))
      end
      local rv={}
      for k,v in pairs(x) do rv[k]=self(v) end
      return self.encode(rv)
    end
    error('unknown type' .. type(x))
  end,
})
