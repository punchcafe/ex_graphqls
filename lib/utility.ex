defmodule Graphqls.Utility do

    @whitespace 32
    
    def split_by_spaces(tokens, chunks) do
        split_by_spaces(tokens, chunks, [], [])
      end
    
    defp split_by_spaces(tokens, 0, _, acc) do
        {Enum.reverse(acc), tokens}
    end

    defp split_by_spaces([@whitespace | rest], chunks, char_acc, acc) do
        split_by_spaces(rest, chunks - 1, [], [Enum.reverse(char_acc) | acc])
    end

    defp split_by_spaces([char | rest], chunks, char_acc, acc) do
        split_by_spaces(rest, chunks, [char | char_acc], acc)
    end
end