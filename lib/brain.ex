defmodule HedwigBrain.Brain do

  defmacro __using__(_) do
    quote do
      @behaviour HedwigBrain.Brain
      
      def save, do: :ok
      def load, do: :ok
      def lookup, do: :ok
      def stop, do: :ok
    end
  end  

  @doc "do any necessary setup"
  @callback load() :: :ok

  @doc "if the brain only writes to durable storage periodically, implement this"
  @callback save() :: :ok  

  @doc """
    get (creating if necessary) a storage namespace in the brain.
    what it returns will be implementation specific
  """
  @callback get_lobe(lobe_name :: term) :: term
  
  @doc "do whatever cleanup is necessary and shutdown"
  @callback stop() :: :ok

  @doc "output a map of all the contents of the brain"
  @callback dump :: map

  @doc "put a value into the specified lobe of the brain" 
  @callback put(lobe :: atom, key :: term, value :: term) :: :ok

  @doc "retrieve a value from the specified lobe"
  @callback get(lobe :: atom, key :: term) :: term

  @doc "retrieve all values from the specified lobe"
  @callback all(lobe :: atom) :: map
  
  @doc "delete a value from the specified lobe"
  @callback delete(lobe :: atom, key :: term) :: :ok

  @doc "delete all items from the specified lobe"
  @callback delete_all(lobe :: atom) :: :ok  

end