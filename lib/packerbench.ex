defmodule Packerbench do
  def start(_, _) do
    #speed()
    #profile()
    :ok
  end

  def speed() do
    Packerbench.Speed.encoding()
  end

  def size() do
    Packerbench.Size.encoding(:compress)
    Packerbench.Size.encoding()
  end

  def profile() do
    #Packerbench.Profile.encoding_tuplemap()
    Packerbench.Profile.encoding_list_of_numbers()
    #Packerbench.Profile.encoding_list_of_tuples()
    #Packerbench.Profile.large_tuple_map()
  end
end
