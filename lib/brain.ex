defmodule HedwigBrain.Brain do

  defmacro __using__(_) do
    quote do
      @behaviour HedwigBrain.Brain

      def save do
      end

      def load do        
      end
    end
  end  

  @doc "do any necessary setup"
  @callback load() :: :ok

  @doc "get (creating if necessary) a storage namespace in the brain"
  @callback get_lobe(lobe_name :: term) :: pid
  
  @doc "do whatever cleanup is necessary and shutdown"
  @callback stop() :: :ok

  @doc "output a map of all the contents of the brain"
  @callback dump :: map

  @doc "put a value into the specified lobe of the brain" 
  @callback put(lobe :: atom, key :: term, value :: term) :: :ok

  @doc "retrieve a value from the specified lobe"
  @callback get(lobe :: atom, key :: term) :: term

  @doc "delete a value from the specified lobe"
  @callback delete(lobe :: atom, key :: term) :: :ok

end