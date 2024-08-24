local driver = require "mongo"
local getmetatable = debug and debug.getmetatable or getmetatable

local function add(self)
  if type(self)~='table' or getmetatable(self) then return self end
  if type(self[1])~='nil' then self.__array=true end
  for k,v in pairs(self) do add(v) end
  return self
end

local function clear(self)
  if type(self)~='table' then return self end
  setmetatable(self, nil)
  self.__array=nil
  for k,v in pairs(self) do clear(v) end
  return self
end

--if is.lua_version('5.1') then
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
--end
