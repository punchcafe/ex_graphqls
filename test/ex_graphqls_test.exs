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

    assert Graphqls.Tokenizer.tokenize(text) == [
             "\"\n",
             "this",
             "is",
             "a",
             "multiline",
             "docstring.\n",
             "\"",
             "type",
             "AClass",
             "{",
             "aField:",
             "String!",
             "}"
           ]
  end

  test "tokensises sda correctly" do
    text = ~s(
    """
    this is a multiline docstring.
    """
    """
    so is this.
    """
    )

    assert ExGraphqls.Parser.parse(text) ==
             {:ok,
              %{
                current_annotiations: [],
                current_docstrings: ["\n this is a multiline docstring.\n", "\n so is this.\n"],
                elements: []
              }}
  end

  test "checks meta correctly" do
    tokens = ["\"here", "it", "is", "man\"", "!"]

    assert ExGraphqls.MetaParser.extract_meta(tokens, %{}) ==
             {["!"], %{docstring: "here it is man"}}
  end
end
