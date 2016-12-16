defmodule HedwigBrain.Redis.Brain do
  use Supervisor
  use HedwigBrain.Brain

  alias HedwigBrain.Redis.Lobe
  alias HedwigBrain.Redis.Registry

  @registry_name HedwigBrain.Redis.Registry
  @lobe_supervisor_name HedwigBrain.Redis.LobeSupervisor

  def start_link(opts) do
    Supervisor.start_link(__MODULE__, :ok, Keyword.merge(opts, name: __MODULE__))
  end

  def init(:ok) do    
    children = [
      supervisor(@lobe_supervisor_name, [[name:  @lobe_supervisor_name]]),      
      worker(@registry_name, [[name: @registry_name]])
    ]
    supervise(children, strategy: :one_for_one)    
  end

  def get_lobe(name), do: Lobe.new(name)

  defdelegate brain, to: HedwigBrain    
  defdelegate dump, to: Registry
  defdelegate get(lobe, key), to: Lobe
  defdelegate put(lobe, key, value), to: Lobe
  defdelegate delete(lobe, key), to: Lobe
  defdelegate delete_all(lobe), to: Lobe
  defdelegate all(lobe), to: Lobe
  
end
