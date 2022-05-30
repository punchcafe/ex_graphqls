defmodule ExGraphqls.FieldParser do
  #### Field Parser methods to be extracted

  alias Graphqls.Utility

  @type field_type :: %{name: atom(), nullable?: boolean()}
  @type field_def :: {:repeated, nullable? :: atom(), field_type()} | field_type()

  @behaviour ExGraphqls.Parser

  @type type_def :: {:type_def, interfaces :: [atom()], fields :: FieldParser.field_defs()}

  @whitespace 32
  #### TODO
  def handles?(_) do
  end

  def handles?(_), do: false

  def handle(context, tokens) do
    # split by first and second instance of space. 
  end

  def parse_field_declaration(tokens, ctx = %{context_stack: [field_declaration | rest]}) do
    {[field_name, field_type], tokens} = Utility.split_by_spaces(tokens, 2)
    [field_name, ""] = String.split(to_string(field_name), ":")
    field_type = parse_field_type(to_string(field_type))
    field_def = {:field, field_name, field_type}
    # TODO: check annotations 
    field_declarations =
      Map.update(field_declaration, :fields, [field_def], fn existing ->
        [field_def | existing]
      end)

    {tokens, %{ctx | context_stack: [field_declarations | rest]}}
  end

  def parse_field_type("[" <> type_string) do
    case String.reverse(type_string) do
      "!]" <> rest -> {:repeated, false, rest |> String.reverse() |> parse_field_type()}
      "]" <> rest -> {:repeated, true, rest |> String.reverse() |> parse_field_type()}
    end
  end

  def parse_field_type(type_string) do
    nullable? = if String.ends_with?(type_string, "!"), do: false, else: true
    name = if not nullable?, do: String.slice(type_string, 0..-2), else: type_string
    %{name: name, nullable?: nullable?}
  end
end
