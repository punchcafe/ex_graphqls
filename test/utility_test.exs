defmodule ExGraphqls.UtilityTest do
  use ExUnit.Case, async: false

  alias Graphqls.Utility

  describe "split_by_spaces/2" do
    test "splits by whitespace" do
      sample =
        """
        The quick brown fox jumped over something I can't remember.
        """
        |> String.to_charlist()

      assert Utility.split_by_spaces(sample, 2) ==
               {['The', 'quick'], 'brown fox jumped over something I can\'t remember.\n'}
    end

    test "ignores duplicate whitespace" do
      sample =
        """
        The      quick     brown fox jumped over something I can't remember.
        """
        |> String.to_charlist()

      assert Utility.split_by_spaces(sample, 3) ==
               {['The', 'quick', 'brown'], 'fox jumped over something I can\'t remember.\n'}
    end
  end
end
