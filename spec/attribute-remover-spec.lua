local attribute_remover = require('../attribute-remover')

describe("attribute_remover", function ()
  describe("delete_attributes", function ()
    it("supports removing shallow attributes", function ()
      local source = {
        first = "first-value",
        second = "second-value",
        third = "third-value"
      }
      local result = attribute_remover
        .delete_attributes(source, { "first", "second" })
      local expected = { third = "third-value" }
      assert.are.same(expected, result)
    end)

    it("does not modify the input", function ()
      local source = { foo = "bar" }
      attribute_remover.delete_attributes(source, { "foo" })
      assert.are.same({ foo = "bar" }, source)
    end)

    it("supports removing nested attributes", function ()
      local source = { foo = { bar = "baz", quz = "qux", lorem = "ipsum" } }
      local result = attribute_remover
        .delete_attributes(source, { "foo.bar", "foo.quz" })
      assert.are.same({ foo = { lorem = "ipsum" } }, result)
    end)

    it('supports removing table attributes', function ()
      local source = { foo = { bar = "baz" } }
      local result = attribute_remover.delete_attributes(source, { "foo" })
      assert.are.same({ }, result)
    end)

    context("when attribute does not exist", function ()
      it("removes nothing on shallow attributes", function ()
        local source = { foo = "bar" }
        local result = attribute_remover.delete_attributes(source, { "baz" })
        assert.are.same(source, result)
      end)

      it("removes nothing on nested attributes", function ()
        local source = { foo = { bar = "baz" } }
        local result = attribute_remover
          .delete_attributes(source, { "foo.bar.quz.qux" })
        assert.are.same(source, result)
      end)
    end)
  end)
end)
