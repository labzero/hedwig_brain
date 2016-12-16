defmodule HedwigBrain.Redis.Registry do
  use GenServer

  alias HedwigBrain.Redis.Lobe
  alias HedwigBrain.Redis.LobeSupervisor

  def start_link(opts \\ []) do
    GenServer.start_link(__MODULE__, {}, Keyword.merge(opts, [name: __MODULE__]))    
  end

  def get_lobe(name) do
    get_lobe(__MODULE__, name)    
  end

  def get_lobe(server, name) do
    GenServer.call(server, {:get, name})
  end

  def dump do
    dump(__MODULE__)
  end

  def dump(server) do
    GenServer.call(server, :dump)  
  end

  def init(_state) do
    {:ok, %{names: %{}, refs: %{}}}
  end

  def handle_call({:get, name}, _from, %{names: names} = state) do
    case Map.fetch(names, name) do
      {:ok, pid} -> {:reply, pid, state}
      _ -> 
        {pid, new_state} = create(state, name)
        {:reply, pid, new_state}
    end   
  end

  def handle_call(:dump, _from, %{names: names, refs: _} = state) do
    data
      = names
      |> Enum.map(fn {name, pid} -> {name, Lobe.all(%Lobe{name: name, conn: pid})} end)
      |> Enum.into(%{})
    {:reply, data, state}
  end

  defp create(%{names: names, refs: refs} , name) do
    {:ok, pid} = LobeSupervisor.start_lobe
    ref = Process.monitor(pid)
    {pid, %{names: Map.put(names, name, pid), refs: Map.put(refs, ref, pid)}}
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