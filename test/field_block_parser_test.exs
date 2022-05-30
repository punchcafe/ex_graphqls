defmodule ExGraphqls.FieldBlockParserTest do
  use ExUnit.Case, async: false

  alias ExGraphqls.FieldBlockParser

  describe "FieldBlockParser.handle/2" do
    test "parses field declaration" do
      blocks = "{ name: String! ids: [Integer!] }" |> String.to_charlist()

      assert {%{
                context_stack: [
                  %{
                    fields: [
                      {:field, "name", %{name: "String", nullable?: false}},
                      {:field, "ids",
                       %{list: {true, :nullable}, name: "Integer", nullable?: false}}
                    ]
                  }
                ]
              }, []} = FieldBlockParser.handle(%{context_stack: []}, blocks)
    end

    test "parses field declaration without spaces between blocks" do
      blocks = "{name: String! ids: [Integer!]}" |> String.to_charlist()

      assert :ok = FieldBlockParser.handle(%{context_stack: []}, blocks)
    end
  end
end
