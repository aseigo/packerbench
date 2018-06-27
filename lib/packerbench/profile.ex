defmodule Packerbench.Profile do
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
  end

  def encoding_list_of_numbers() do
    list = Enum.reduce(1..1_000_000, [], fn x, acc -> [x|acc] end)

    #profile do
    Toolbelt.time(fn -> Packer.encode(list, compress: false) end) |> IO.inspect
      #end

    :done
  end

  def encoding_list_of_tuples() do
    list = Enum.reduce(1..500, [], fn  x, acc -> [{x * 2, x * 2 + 1} | acc] end)

    profile do
      Packer.encode(list, compress: false)
    end

    :done
  end

  def iolist_join() do
    iolist = Enum.reduce(1..10000, [], fn  _, acc -> ["a" | acc] end)
    (for _ <- 1..10, do: Toolbelt.time(fn -> Enum.join(iolist) end)) |>IO.inspect
    (for _ <- 1..10, do: Toolbelt.time(fn -> Enum.reduce(1..10000, "", fn _, acc -> acc <> "a" end) end)) |>IO.inspect
  end

  def large_tuple_map() do
    tuple_list = Enum.reduce(1..500, [], fn  x, acc -> [{x * 2, x * 2 + 1} | acc] end)
    tuple_map = Enum.reduce(1..10_000, %{},
                            fn x, acc ->
                              Map.put(acc, {x * 2, x * 2 + 1}, tuple_list)
                            end)
    Toolbelt.time(fn -> Packer.encode(tuple_map) end) |> IO.inspect(label: "Encoding large tuple map")
  end

  def send_large_tuple_map(remote, reps \\ 2) do
    tuple_list = Enum.reduce(1..500, [], fn  x, acc -> [{x * 2, x * 2 + 1} | acc] end)
    tuple_map = Enum.reduce(1..100_000, %{},
                            fn x, acc ->
                              Map.put(acc, {x * 2, x * 2 + 1}, tuple_list)
                            end)
    Node.ping(remote)
    rpid = Node.spawn(remote, fn -> Packerbench.Profile.recv_large_tuple_map(reps) end)
    send(rpid, :start)
    Enum.each(1..reps, fn _ -> send(rpid, tuple_map) end)
  end

  def recv_large_tuple_map(reps, since \\ 0)

  def recv_large_tuple_map(0, since) do
    ((:os.system_time() - since) / 1_000_000)
    |> IO.inspect(label: "Elapsed")
  end

  def recv_large_tuple_map(reps, since) do
    receive do
      :start -> 
        recv_large_tuple_map(reps, :os.system_time())
      _ -> recv_large_tuple_map(reps - 1, since)
    end
  end
end
