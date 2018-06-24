defmodule Packerbench.Speed do
  def encoding() do
    encode([], "empty list")

    tuple_list = Enum.reduce(1..500, [], fn  x, acc -> [{x * 2, x * 2 + 1} | acc] end)
    encode(tuple_list, "list of tuples")

    small_tuple_map = Enum.reduce(1..100, %{},
                                  fn x, acc ->
                                    Map.put(acc, {x * 2, x * 2 + 1}, tuple_list)
                                  end)
    encodesmall_tuple_map, "map of tuples to list of tuples")

    large_tuple_map = Enum.reduce(1..10_000, %{},
                                  fn x, acc ->
                                    Map.put(acc, {x * 2, x * 2 + 1}, tuple_list)
                                  end)
    encode_only_packer(large_tuple_map, "large map of tuples to list of tuples")
  end

  def encode(term, name) do
    Benchee.run %{
      "Encode #{name} with :erlang.term_to_binary" =>
        fn -> :erlang.term_to_binary(term) end,
      "Encode #{name} with Packer.encode" =>
        fn -> Packer.encode(term) end
    }, formatters: [&Benchee.Formatters.HTML.output/1],
      formatter_options: [html: [file: "benchmarks/#{String.replace(name, " ", "_")}.html"]]
  end

  def encode_only_packer(term, name) do
    Benchee.run %{
      "Encode #{name} with Packer.encode" =>
        fn -> Packer.encode(term) end
    }, formatters: [&Benchee.Formatters.HTML.output/1],
      formatter_options: [html: [file: "benchmarks/#{String.replace(name, " ", "_")}.html"]]
  end
end
