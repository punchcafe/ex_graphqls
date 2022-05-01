defmodule ExGraphqls.DocstringParser do
  @type meta :: %{directives: [%{name: String.t(), args: %{}}], docstring: String.t()}
  @behaviour ExGraphqls.Parser

  def handles?("\"" <> _), do: true
  # TODO: handle annotations?
  def handles?(_), do: false

  def handle(context, tokens = [token | _]) do
    extract_meta(tokens, context)
  end

  def extract_meta(["\"" <> rest | tokens], context = %{current_docstrings: docstrings}) do
    {remainder, docstring} = extract_docstring([rest | tokens])
    new_docstrings = docstrings ++ [docstring]
    {%{context | current_docstrings: new_docstrings}, remainder}
  end

  defp extract_docstring(token_list) do
    extract_docstring(token_list, [])
  end

  defp extract_docstring([head | tail], acc) do
    cond do
      head == "\"" ->
        {tail, Enum.reverse(acc) |> Enum.join(" ")}

      String.ends_with?(head, "\"") ->
        "\"" <> reversed = String.reverse(head)
        {tail, Enum.reverse([String.reverse(reversed) | acc]) |> Enum.join(" ")}

      true ->
        extract_docstring(tail, [head | acc])
    end
  end
end
