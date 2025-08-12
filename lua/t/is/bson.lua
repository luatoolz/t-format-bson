local mongo = assert(require('mongo'), 'no mongo')
return function(x) return (type(x)=='userdata' and mongo.type(x)=='mongo.BSON') and true or nil end