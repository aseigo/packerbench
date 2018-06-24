defmodule Packerbench.Size do
  def encoding(compress \\ :no) do
    encode([], "empty list", compress)

    tuple_list = Enum.reduce(1..500, [], fn  x, acc -> [{x * 2, x * 2 + 1} | acc] end)
    encode(tuple_list, "list of tuples", compress)

    small_tuple_map = Enum.reduce(1..100, %{},
                                  fn x, acc ->
                                    Map.put(acc, {x * 2, x * 2 + 1}, tuple_list)
                                  end)
    encode(small_tuple_map, "map of tuples to list of tuples", compress)

    large_tuple_map = Enum.reduce(1..10_000, %{},
                                  fn x, acc ->
                                    Map.put(acc, {x * 2, x * 2 + 1}, tuple_list)
                                  end)
    encode_only_packer(large_tuple_map, "large map of tuples to list of tuples", compress)
  end

  def encode(term, name, compress_opt \\ :no) do
    compress = compress_opt == :compress
    IO.puts("Encoding size test: #{name}")
    if compress do
      IO.puts("    Compression ON")
    end

    erl_opts =
      if compress do
        [:compressed]
      else
        []
      end

    erl =
      term
      |> :erlang.term_to_binary(erl_opts)
      |> byte_size()

    packer =
      term
      |> Packer.encode(format: :binary, compress: compress)
      |> byte_size()

    IO.puts("    term_to_binary: #{erl} bytes")
    IO.puts("    packer encoded: #{packer} bytes")
    IO.puts("    difference: #{erl - packer} bytes")
    IO.puts("    improvement: #{Float.round((1 - (packer / erl)) * 100, 2)}%")
  end

  def encode_only_packer(term, name, compress_opt) do
    compress = compress_opt == :compress
    IO.puts("Encoding size test: #{name}")
    if compress do
      IO.puts("    Compression ON")
    end

    packer =
      term
      |> Packer.encode(format: :binary, compress: compress)
      |> byte_size()

    IO.puts("    packer encoded: #{packer} bytes")
  end
end
