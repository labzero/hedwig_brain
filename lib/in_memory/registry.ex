defmodule HedwigBrain.InMemory.Registry do
  use GenServer

  alias HedwigBrain.InMemory.LobeSupervisor
  alias HedwigBrain.InMemory.Lobe

  def start_link(opts \\ []) do
    GenServer.start_link(__MODULE__, {}, Keyword.merge(opts, [name: __MODULE__]))    
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
    {:ok, %{names: %{}, refs: %{}}}
  end

  def handle_call({:lookup, name}, _from, %{names: names} = state) do
    {:reply, Map.fetch(names, name), state}
  end

  def handle_call({:create, name}, _from, %{names: names, refs: refs} = state) do
    case Map.fetch(names, name) do
      {:ok, pid} ->
        {:reply, pid, state}
      :error ->
        {:ok, pid} = LobeSupervisor.start_lobe
        ref = Process.monitor(pid)
        {:reply, pid, %{names: Map.put(names, name, pid), refs: Map.put(refs, ref, name)}}
    end
  end

  def handle_call(:dump, _from, %{names: names} = state) do
    data 
      = names
      |> Enum.map(fn {name, pid} -> {name, Lobe.all(pid)} end)
      |> Enum.into(%{})
    {:reply, data, state}
  end

  def handle_call(:stop, _from, state) do
    {:stop, :normal, :ok, state}
  end  

  # remove dead processes from our state
  def handle_info({:DOWN, ref, :process, _pid, _reason}, {names, refs}) do
    {name, refs} = Map.pop(refs, ref)
    names = Map.delete(names, name)
    {:noreply, {names, refs}}
  end

  def handle_info(_msg, state) do
    {:noreply, state}
  end  
end