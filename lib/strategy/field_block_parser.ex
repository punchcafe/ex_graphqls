defmodule ExGraphqls.FieldBlockParser do
  @behaviour ExGraphqls.Parser

  @whitespace 32
  # TODO: add directive annotations
  @ordered_parsers [ExGraphqls.DocstringParser, ExGraphqls.FieldParser]
  defp new_field_block_context(), do: %{fields: []}

  def handles?([?{ | _]), do: true

  def handle(%{context_stack: context_stack}, [?{ | rest]),
    do: handle(%{context_stack: [new_field_block_context() | context_stack]}, rest)

  def handle(%{context_stack: [field_block_ctx = %{fields: fields} | rest]}, [?} | rest]) do
    reversed_field_ctx =
      fields
      |> Enum.reverse()
      |> then(&Map.put(field_block_ctx, :fields, &1))
      |> then(&Map.put(field_block_ctx, :context_stack, [&1 | rest]))

    {reversed_field_ctx, rest}
  end

  def handle(context, [@whitespace | rest]), do: handle(context, rest)

  def handle(context, tokens) do
    {context, tokens} =
      @ordered_parsers
      |> Enum.find(& &1.handles?(tokens))
      |> then(& &1.handle(context, tokens))

    handle(context, tokens)
  end
end
