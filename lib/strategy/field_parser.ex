defmodule ExGraphqls.FieldParser do
  #### Field Parser methods to be extracted

  @type field_type :: %{name: atom(), nullable?: boolean()}
  @type field_def :: {:repeated, nullable? :: atom(), field_type()} | field_type()

  @behaviour ExGraphqls.Parser

  @type type_def :: {:type_def, interfaces :: [atom()], fields :: FieldParser.field_defs()}

alias Graphqls.Utility

  @whitespace 32
  #### TODO
  def handles?(_) do
  end
  def handles?(_), do: false

  def handle(context, tokens) do
    # split by first and second instance of space. 

  end

  def parse_field_declaration(tokens, context) do
      with {[field_name, field_type], tokens} <- Utility.split_by_spaces(tokens, 2) do
          :ok
      end
      #TODO: implement rest

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
