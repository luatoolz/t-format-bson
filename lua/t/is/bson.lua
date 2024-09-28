local t=t or require "t"
local bson=t.format.bson
return function(x) return type(x)=='userdata' and bson.type(x)=='mongo.BSON' end