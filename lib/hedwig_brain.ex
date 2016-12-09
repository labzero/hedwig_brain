defmodule HedwigBrain do
  use Application

  @brain_type Application.get_env(:hedwig_brain, :brain_type)

  # See http://elixir-lang.org/docs/stable/elixir/Application.html
  # for more information on OTP Applications
  def start(_type, _args) do
    @brain_type.start_link(name: __MODULE__)
  end

  def brain do
    @brain_type
  end
end
