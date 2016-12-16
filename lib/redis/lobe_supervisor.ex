defmodule HedwigBrain.Redis.LobeSupervisor do
  use Supervisor

  @redis Application.get_env(:hedwig_brain, :redis_url) || "redis://localhost:6379/1"

  def start_link(opts \\ []) do
    Supervisor.start_link(__MODULE__, :ok, Keyword.merge(opts, [name: __MODULE__]))
  end

  def start_lobe do
    Supervisor.start_child(__MODULE__, [])
  end

  def init(:ok) do
    children = [
      worker(Redix, [@redis], restart: :temporary)
    ]

    supervise(children, strategy: :simple_one_for_one)
  end
end