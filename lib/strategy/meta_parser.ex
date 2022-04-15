defmodule ExGraphqls.MetaParser do
    @type meta :: %{directives: [%{name: String.t(), args: %{}}], docstring: String.t()}

    def extract_meta(["@" <> rest | tokens], meta) do
        #TODO:
        nil
    end

    def extract_meta(["\"" <> rest | tokens], meta) do
        {remainder, docstring} = extract_docstring([rest|tokens])
        extract_meta(remainder, Map.put(meta, :docstring, docstring))
    end

    def extract_meta(rest, meta) do
        {rest, meta}
    end

    defp extract_docstring(token_list) do
        extract_docstring(token_list, [])
    end

    defp extract_docstring([head | tail], acc) do
        cond do
            head == "\"" -> {tail, Enum.reverse(acc) |> Enum.join(" ")}
            String.ends_with?(head, "\"") -> 
                "\"" <> reversed = String.reverse(head)
                {tail, Enum.reverse([String.reverse(reversed)| acc]) |> Enum.join(" ")}
            true -> extract_docstring(tail, [head | acc])
        end
    end
end