defmodule ExGraphqls.FieldParser do
  #### Field Parser methods to be extracted

  alias Graphqls.Utility

  @type type_spec :: %{
          name: atom(),
          nullable?: boolean(),
          list: false | {true, :nullable} | {true, :non_nullable}
        }
  @type field_declaration :: %{name: atom(), type: type_def()}

  @behaviour ExGraphqls.Parser

  @type type_def :: {:type_def, interfaces :: [atom()], fields :: FieldParser.field_defs()}

  @whitespace 32
  #### TODO
  def handles?(_) do
    true
  end

  def handle(context, tokens) do
    parse_field_declaration(tokens, context)
    # TODO: # split by first and second instance of : so we can get the args out. 
  end

  def parse_field_declaration(tokens, ctx = %{context_stack: [field_block_context | rest]}) do
    {[field_name, field_type], tokens} = Utility.split_by_spaces(tokens, 2)
    [field_name, ""] = String.split(to_string(field_name), ":")
    field_type = parse_field_type(to_string(field_type))
    field_def = {:field, field_name, field_type}
    # TODO: check annotations 
    field_block_context =
      Map.update(field_block_context, :fields, [field_def], fn existing ->
        [field_def | existing]
      end)

    {%{ctx | context_stack: [field_block_context | rest]}, tokens}
  end

  def parse_field_type("[" <> type_string) do
    case String.reverse(type_string) do
      "!]" <> rest ->
        rest |> String.reverse() |> parse_field_type() |> Map.put(:list, {true, :non_nullable})

      "]" <> rest ->
        rest |> String.reverse() |> parse_field_type() |> Map.put(:list, {true, :nullable})
    end
  end

  def parse_field_type(type_string) do
    nullable? = if String.ends_with?(type_string, "!"), do: false, else: true
    name = if not nullable?, do: String.slice(type_string, 0..-2), else: type_string
    %{name: name, nullable?: nullable?}
  end
end
