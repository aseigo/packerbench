defmodule Packer.Profile do
  import ExProf.Macro

  def encoding_tuplemap() do
    tuple_list = Enum.reduce(1..500, [], fn  x, acc -> [{x * 2, x * 2 + 1} | acc] end)
    small_tuple_map = Enum.reduce(1..100, %{},
                                  fn x, acc ->
                                    Map.put(acc, {x * 2, x * 2 + 1}, tuple_list)
                                  end)

    profile do
      Packer.encode(small_tuple_map, compress: false)
    end
    :ok
  end
end
