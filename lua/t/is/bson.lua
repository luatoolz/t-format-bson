local driver=require"mongo"
return function(x) return type(x)=='userdata' and driver.type(x)=='mongo.BSON' end