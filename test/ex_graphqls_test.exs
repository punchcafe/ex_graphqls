defmodule ExGraphqlsTest do
  use ExUnit.Case
  doctest ExGraphqls

  test "tokensises graphqls correctly" do
    text = ~s(
    """
    this is a multiline docstring.
    """
    type AClass {
      aField: String!
    }
    )
    assert Graphqls.Parser.tokenise_text(text) == ["\"\n", "this", "is", "a", "multiline", "docstring.\n", "\"", "type", "AClass", "{", "aField:", "String!", "}"]
  end
end
