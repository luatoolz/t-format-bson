describe("bson", function()
  local t, bson, is
  setup(function()
    t = require "t"
    is = t.is
    bson = t.format.bson
  end)
	it("load", function()
    assert.is_table(bson)
    assert.is_table(getmetatable(bson))
  end)
  it("bson", function()
    assert.bson(bson{})
    assert.equal('{ }', tostring(bson{}))
    assert.equal('mongo.BSON', bson.type(bson{}))
    assert.bson(bson{})

    local data=bson({x=7})
    assert.equal('number', type(data:find('x')))
    assert.equal('number', bson.type(data:find('x')))
    assert.equal('{ "x" : 7 }', tostring(data))

    data=bson({x="7"})
    assert.equal('string', type(data:find('x')))
    assert.equal('string', bson.type(data:find('x')))
    assert.equal('{ "x" : "7" }', tostring(data))

    data=bson({x=true})
    assert.equal('boolean', type(data:find('x')))
    assert.equal('boolean', bson.type(data:find('x')))
    assert.equal('{ "x" : true }', tostring(data))

    data=bson('["x"]')
    assert.equal('mongo.BSON', bson.type(data))
    assert.same({"x"}, bson.decode(data))
    assert.same({"x"}, data())

    data=bson({"x"})
    assert.same({"x"}, data:value())

    data=bson({"x"})
    assert.same({"x"}, data:value())

    data=bson({x={}})
    assert.equal(bson{x={}}, data)

    data=bson({x={'a', 'b'}})
    assert.same({x={'a', 'b'}}, data:value())
    assert.equal(bson{x={[1]='a', [2]='b'}}, data)
    assert.equal(bson{x={'a','b'}}, data)

    data=bson({'a', 'b'})
    assert.same({'a', 'b'}, data:value())
    assert.equal(bson{[1]='a', [2]='b'}, data)
    assert.equal(bson{'a','b'}, data)

    assert.equal(bson{x={'q'}}, bson({x=t.array('q')}))
    assert.equal(bson{x={}}, bson({x=t.array()}))

    data=bson({x=t.array(1,2)})
    assert.equal(bson{x={1,2}}, data)
    assert.equal(bson{x={1,2}}, data)
    assert.equal(data, bson('{"x":[1,2]}'))
    assert.equal(bson('{"x":[1,2]}'), data)
    assert.equal(bson{x={1,2}}, bson('{"x":[1,2]}'))

    data=bson({x=t.set("x","y")})
    assert.equal(bson{x={[1]="x",[2]="y"}}, data)
    assert.equal(bson{x={"x","y"}}, data)
    assert.equal(bson{x={[1]="x",[2]="y"}}, data)
    assert.equal(bson{x={"x","y"}}, data)

    data=bson({x={"x","y"}})
    assert.equal(bson{x={"x","y"}}, data)

    data=bson({x={1,2}})
    assert.equal(bson{x={1,2}}, data)
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

    assert.bson(bson{})
    assert.bson(bson{})
    assert.not_bson(bson(nil))
  end)
	it("encode", function()
		assert.is_nil(bson())
		assert.is_nil(bson(nil))

--		assert.equal(7, bson(7))
--		assert.equal(7.2, bson(7.2))
--		assert.equal('7', bson('7'))
--		assert.equal('', bson(''))
--		assert.equal(true, bson(true))
--		assert.equal(false, bson(false))

		assert.equal('{ }', tostring(bson({})))
		assert.same({}, bson({}):value())

		assert.equal(bson{}, bson{})
		assert.equal(bson{}, bson(t.array()))
		assert.equal(bson{"a"}, bson(t.array({"a"})))

		assert.equal(bson{x={}}, bson{x={}})
		assert.equal(bson{x={}}, bson{x=t.array()})
		assert.equal(bson{x={"a"}}, bson{x=t.array({"a"})})
		assert.equal(bson{x={1, 2}}, bson{x=t.array(1,2)})

		assert.equal(bson{x={}}, bson{x=t.set()})
		assert.equal(bson{x={1, 2}}, bson{x=t.set(1,2)})
		assert.equal(bson{x={1, 2}}, bson{x=t.set(2,1)})
	end)
  it("decode", function()
    assert.same({x={"x"}}, bson.decode(bson({x={"x"}})))
  end)
end)
