defmodule ExGraphqls.FieldParserTest do
  use ExUnit.Case, async: false

  alias ExGraphqls.FieldParser

  describe "FieldParser.parse_field/1" do
    test "parses field declaration" do
      declaration = "name: String! ids: [Integer!]" |> String.to_charlist()

      assert {%{
                context_stack: [
                  %{
                    declared_fields: [],
                    fields: [{:field, "name", %{name: "String", nullable?: false}}]
                  }
                ]
              },
              'ids: [Integer!]'} =
               FieldParser.parse_field_declaration(declaration, %{
                 context_stack: [%{declared_fields: []}]
               })
    end
  end

  describe "FieldParser.parse_field_type/1" do
    test "can parse a simple nullable type" do
      assert %{name: "String", nullable?: true} == FieldParser.parse_field_type("String")
    end

    test "can parse a simple non-nullable type" do
      assert %{name: "String", nullable?: false} == FieldParser.parse_field_type("String!")
    end

    test "can parse a simple nullable list" do
      assert {:repeated, true, %{name: "String", nullable?: true}} ==
               FieldParser.parse_field_type("[String]")
    end

    test "can parse a simple non-nullable list" do
      assert {:repeated, false, %{name: "String", nullable?: true}} ==
               FieldParser.parse_field_type("[String]!")
    end

    test "can parse a simple non-nullable list and type" do
      assert {:repeated, false, %{name: "String", nullable?: false}} ==
               FieldParser.parse_field_type("[String!]!")
    end
  end
end
