defmodule HedwigBrain.InMemory.LobeSupervisor do
  use Supervisor

  @name HedwigBrain.InMemory.LobeSupervisor

  def start_link(opts \\ []) do
    Supervisor.start_link(__MODULE__, :ok, Keyword.merge(opts, [name: @name]))
  end

  def start_lobe do
    Supervisor.start_child(@name, [])
  end

  def init(:ok) do
    children = [
      worker(HedwigBrain.InMemory.Lobe, [], restart: :temporary)
    ]

    supervise(children, strategy: :simple_one_for_one)
  end
end