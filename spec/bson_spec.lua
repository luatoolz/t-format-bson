describe("bson", function()
  local t, driver, bson, is
  setup(function()
    t = require "t"
    is = t.is
    bson = require "t.format.bson"
    driver = require "mongo"
  end)
	it("load", function()
    assert.is_table(bson)
    assert.is_table(getmetatable(bson))
  end)
  it("driver.BSON", function()
    assert.bson(driver.BSON{})
    assert.equal('{ }', tostring(driver.BSON{}))
    assert.equal('mongo.BSON', bson.type(driver.BSON{}))
    assert.equal(true, bson.mongo(driver.BSON{}))

    local data=driver.BSON({x=7})
    assert.equal('number', type(data:find('x')))
    assert.equal('number', driver.type(data:find('x')))
    assert.equal('{ "x" : 7 }', tostring(data))

    data=driver.BSON({x="7"})
    assert.equal('string', type(data:find('x')))
    assert.equal('string', driver.type(data:find('x')))
    assert.equal('{ "x" : "7" }', tostring(data))

    data=driver.BSON({x=true})
    assert.equal('boolean', type(data:find('x')))
    assert.equal('boolean', driver.type(data:find('x')))
    assert.equal('{ "x" : true }', tostring(data))

    data=driver.BSON('["x"]')
    assert.same({"x"}, data:value())

    data=driver.BSON({"x"})
    assert.same({"x"}, data:value())

    data=driver.BSON({x=t.array()})
    assert.equal(driver.BSON{x={}}, data)

    data=driver.BSON({x=t.array(1,2)})
    assert.equal(driver.BSON{x={1,2}}, data)
    assert.equal(driver.BSON{x={__array=true,1,2}}, data)
    assert.equal(data, driver.BSON('{"x":[1,2]}'))
    assert.equal(driver.BSON{x={__array=true,1,2}}, driver.BSON('{"x":[1,2]}'))

    data=driver.BSON({x=t.set(1,2)})
    assert.equal(driver.BSON{x={1,2}}, data)
  end)
	it("is", function()
    assert.is_false(is.bson())
    assert.is_false(is.bson(''))
    assert.is_false(is.bson(' '))
    assert.is_false(is.bson('  '))
    assert.is_false(is.bson('   '))

    assert.is_false(is.bson('null'))
    assert.is_false(is.bson('7'))
    assert.is_false(is.bson('"7"'))

    assert.is_false(is.bson('[]'))
    assert.is_false(is.bson('{}'))
    assert.is_false(is.bson(' {}'))
    assert.is_false(is.bson('{} '))
    assert.is_false(is.bson(' {} '))
    assert.is_false(is.bson(' []'))
    assert.is_false(is.bson('[] '))
    assert.is_false(is.bson(' [] '))

    assert.is_false(is.bson(" {\n} "))
    assert.is_false(is.bson(" [\n] "))

    assert.is_false(is.bson(" \n{\n}\n "))
    assert.is_false(is.bson(" \n[\n]\n "))

    assert.bson(driver.BSON{})
    assert.bson(bson{})
    assert.not_bson(bson(nil))
  end)
	it("encode", function()
		assert.equal(bson.null, bson())
		assert.equal(bson.null, bson(nil))
		assert.equal(bson.null, bson(bson.null))

		assert.equal(7, bson(7))
		assert.equal(7.2, bson(7.2))

		assert.equal('7', bson('7'))
		assert.equal('', bson(''))

		assert.equal(true, bson(true))
		assert.equal(false, bson(false))

		assert.equal('{ }', tostring(bson({})))
		assert.same({}, bson({}):value())

		assert.equal(bson{}, bson{})
		assert.equal(bson{}, bson({}))

		assert.equal(bson{x={}}, bson{x=t.array()})
		assert.equal(bson{x={1, 2}}, bson{x=t.array(1,2)})

		assert.equal(bson{x={}}, bson{x=t.set()})
		assert.equal(bson{x={1, 2}}, bson{x=t.set(1,2)})
		assert.equal(bson{x={1, 2}}, bson{x=t.set(2,1)})
	end)
  it("decode", function()
    assert.same({x={"x"}}, bson.decode(bson({x={"x"}})))
  end)
end)
