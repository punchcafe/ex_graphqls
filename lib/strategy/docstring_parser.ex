defmodule ExGraphqls.DocstringParser do
  @type meta :: %{directives: [%{name: String.t(), args: %{}}], docstring: String.t()}
  @behaviour ExGraphqls.Parser
  @whitespace 32
  def handles?(?"), do: true
  # TODO: handle annotations?
  def handles?(_), do: false

  def handle(context, tokens = [token | _]) do
    extract_meta(tokens, context)
  end

  def extract_meta([?" | tokens], context = %{current_docstrings: docstrings}) do
    {remainder, docstring} = extract_docstring(tokens)
    new_docstrings = docstrings ++ [docstring]
    {%{context | current_docstrings: new_docstrings}, remainder}
  end

  defp extract_docstring(token_list) do
    extract_docstring(token_list, [])
  end

  defp extract_docstring([?/, ?" | tail], acc) do
    extract_docstring(tail, [?" | acc])
  end

  defp extract_docstring([@whitespace, @whitespace | tail], acc) do
    extract_docstring([@whitespace | tail], acc)
  end

  defp extract_docstring([?" | tail], acc) do
    {tail, acc |> Enum.reverse() |> to_string() |> String.trim()}
  end

  defp extract_docstring([h | t], acc) do
    extract_docstring(t, [h | acc])
  end
end
