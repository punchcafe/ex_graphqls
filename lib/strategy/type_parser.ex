defmodule ExGraphqls.TypeParser do
  alias ExGraphqls.FieldParser
  @type meta :: %{directives: [%{name: String.t(), args: %{}}], docstring: String.t()}
  @behaviour ExGraphqls.Parser

  @type type_def :: {:type_def, interfaces :: [atom()], fields :: FieldParser.field_defs()}

  @whitespace 32
  def handles?([?t, ?y, ?p, ?e, 36 | _]), do: true
  def handles?(_), do: false

  def handle(context, tokens = ["type", name, "implements" | tokens]) do
    # TODO:
    # Acts as subset of main parser (rename to TokenParser or something), using subset of strategies.
    # Ordered list of Docstring, Directive, Field Parser means that Field Parser can assume it's always dealing with a field?
  end

  def extract_body_tokens(["{" | tokens]) do
    extract_body_tokens(tokens, [])
  end

  def extract_body_tokens(["}" | tokens], acc), do: {Enum.reverse(acc), tokens}
  def extract_body_tokens([], acc), do: {:error, :no_close_tab}
  def extract_body_tokens([token | tokens], acc), do: extract_body_tokens(tokens, [token | acc])
end
