defmodule HedwigBrain.Brain do

  defmacro __using__(_) do
    quote do
      @behaviour HedwigBrain.Brain

      def save do
        IO.puts("SOS")
      end
    end
  end  

  @callback get_lobe(term) :: pid
  @callback lookup(term) :: pid
  @callback stop() :: :ok
  @callback dump :: map

end