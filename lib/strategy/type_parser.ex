defmodule ExGraphqls.TypeParser do
  alias ExGraphqls.FieldParser
  @type meta :: %{directives: [%{name: String.t(), args: %{}}], docstring: String.t()}
  @behaviour ExGraphqls.Parser

  @type type_def :: {:type_def, interfaces :: [atom()], fields :: FieldParser.field_defs()}

  def handles?("type"), do: true
  def handles?(_), do: false

  def handle(context, tokens = ["type", name, "implements" | tokens]) do
  end

  def extract_body_tokens(["{" | tokens]) do
    extract_body_tokens(tokens, [])
  end

  def extract_body_tokens(["}" | tokens], acc), do: {Enum.reverse(acc), tokens}
  def extract_body_tokens([], acc), do: {:error, :no_close_tab}
  def extract_body_tokens([token | tokens], acc), do: extract_body_tokens(tokens, [token | acc])
end
