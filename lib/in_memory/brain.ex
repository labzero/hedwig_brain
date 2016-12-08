defmodule HedwigBrain.InMemory.Brain do
  use Supervisor
  use HedwigBrain.Brain

  @registry_name HedwigBrain.InMemory.Registry
  @lobe_supervisor_name HedwigBrain.InMemory.LobeSupervisor

  def start_link(opts) do
    Supervisor.start_link(__MODULE__, :ok, opts)
  end

  def init(:ok) do
    children = [
      supervisor( @lobe_supervisor_name, [[name:  @lobe_supervisor_name]]),
      worker(@registry_name, [[name: @registry_name]])
    ]
    supervise(children, strategy: :one_for_one)
  end

  defdelegate get_lobe(name), to: @registry_name
  defdelegate lookup(name), to: @registry_name
  defdelegate dump, to: @registry_name 
  defdelegate stop, to: @registry_name

end
