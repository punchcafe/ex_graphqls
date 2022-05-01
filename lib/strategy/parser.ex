defmodule ExGraphqls.Parser do
  alias Graphqls.Tokenizer
  @type context :: %{current_docstrings: list(), current_directives: list(), elements: list()}
  @callback handles?(token :: binary()) :: boolean
  @callback handle(context(), [binary()]) :: {context(), remainder :: [binary]}

  @all_parsers [ExGraphqls.DocstringParser]

  def parse(binary) do
    tokens = Tokenizer.tokenize(binary)
    parse_recursive(empty_context(), tokens)
  end

  defp empty_context(), do: %{current_annotiations: [], current_docstrings: [], elements: []}

  defp parse_recursive(context, tokens = [next_token | _]) do
    case Enum.find(@all_parsers, fn module -> module.handles?(next_token) end) do
      nil ->
        {:error, :invalid_token}

      mod ->
        {context, tokens} = mod.handle(context, tokens)
        parse_recursive(context, tokens)
    end
  end

  defp parse_recursive(context, tokens = []) do
    {:ok, context}
  end
end
