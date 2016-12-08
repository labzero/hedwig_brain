defmodule HedwigBrain.Lobe do

  defmacro __using__(_) do
    quote do
      @behaviour HedwigBrain.Lobe
    end
  end  

  @callback get(pid, term) :: term
  @callback put(pid, term, term) :: term
  @callback delete(pid, term) :: term
  @callback all(pid) :: map

end