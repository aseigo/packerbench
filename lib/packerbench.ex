defmodule Packerbench do
  def speed() do
    Packerbench.Speed.encoding()
  end

  def size() do
    Packerbench.Size.encoding(:compress)
    Packerbench.Size.encoding()
  end
end
