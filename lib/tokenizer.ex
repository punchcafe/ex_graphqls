defmodule Graphqls.Tokenizer do

    def tokenize(body) do
        body
        |> String.split("\n")
        |> normalize_multiline_comments()
        |> Enum.map(&strip_comments/1)
        |> Enum.flat_map(&String.split(&1, " "))
        |> Enum.reject(&(&1 == ""))
    end

    defp strip_comments(line) do
        if String.contains?(line, ~s(#))  do
            {index, 1} = :binary.match(line, "#")
            {code, _} = String.split_at(index)
            code
        else 
            line
        end
    end

    defp normalize_multiline_comments(lines) do
        normalize_multiline_comments(lines, [], [])
    end

    defp normalize_multiline_comments([], [], line_acc) do
        line_acc |> Enum.reverse()
     end
    
    defp normalize_multiline_comments([line | lines], acc, line_acc) do
        IO.inspect("line: #{line}")
        IO.inspect("acc: #{acc}")
        if String.contains?(line, ~s("""))  do
            {index, 3} = :binary.match(line,  ~s("""))
            {pre_delimiter, ~s(""") <> post_delimiter} = String.split_at(line, index)
            case acc do
                [] -> 
                    IO.inspect "start!"
                    normalize_multiline_comments(lines, [post_delimiter], [pre_delimiter | line_acc])
                    # Means that this is starting a new sigil
                acc -> 
                    # Means this is closing a multiline comment
                    IO.inspect("stop!")
                    normalized_comment = [ pre_delimiter | acc ] |> Enum.reverse() |> Enum.join("\n")
                    IO.inspect("normalised: #{normalized_comment}")
                    IO.inspect("acc: #{acc}")
                    normalize_multiline_comments([post_delimiter | lines], [], [ ~s(") <> normalized_comment <> ~s(") | line_acc]) 
            end
        else
            case acc do
                [] -> normalize_multiline_comments(lines, acc, [line | line_acc])
                acc -> normalize_multiline_comments(lines, [line | acc], line_acc)
            end
            
        end
    end
end