defmodule HedwigBrain.InMemory.Registry do
  use GenServer

  alias HedwigBrain.InMemory.LobeSupervisor
  alias HedwigBrain.InMemory.Lobe

  def start_link(opts \\ []) do
    result = GenServer.start_link(__MODULE__, {}, Keyword.merge(opts, [name: __MODULE__]))
    result
  end

  # API

  def get_lobe(name) do
    get_lobe(__MODULE__, name)
  end

  def get_lobe(server, name) do
    GenServer.call(server, {:create, name})
  end

  def stop do
    stop(__MODULE__)
  end

  def stop(server) do
    GenServer.call(server, :stop)
  end

  def lookup(name) do
    lookup(__MODULE__, name)
  end

  def lookup(server, name) do
    GenServer.call(server, {:lookup, name})
  end  

  def dump do
    dump(__MODULE__)
  end

  def dump(server) do
    GenServer.call(server, :dump)  
  end

  ## Callbacks

  def init(_state) do  
    names = Map.new
    refs  = Map.new
    {:ok, %{names: names, refs: refs}}
  end

  def handle_call({:lookup, name}, _from, names) do
    {:reply, Map.fetch(names, name), names}
  end

  def handle_call({:create, name}, _from, %{names: names, refs: refs} = state) do
    case Map.fetch(names, name) do
      {:ok, pid} ->
        {:reply, pid, state}
      :error ->
        {:ok, pid} = LobeSupervisor.start_lobe
        ref = Process.monitor(pid)
        new_refs = Map.put(refs, ref, name)
        new_names = Map.put(names, name, pid)
        {:reply, pid, %{names: new_names, refs: new_refs}}
    end
  end

  def handle_call(:dump, _from, %{names: names} = state) do
    data = names
    |> Enum.map(fn {name, pid} -> {name, Lobe.all(pid)} end)
    |> Enum.into(%{})
    {:reply, data, state}
  end

  def handle_call(:stop, _from, state) do
    {:stop, :normal, :ok, state}
  end  
end