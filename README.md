# HedwigBrain

Pluggable storage back-ends for Hedwig chat bots

- Available Brains
  - HedwigBrain.InMemory.Brain (a simple GenServer based solution)
  - HedwigBrain.Redis.Brain

- Brains TODO
  - ETS

Brains need to implement the `HedwigBrain.Brain` behaviour

## Installation

If [available in Hex](https://hex.pm/docs/hedwig_brain), the package can be installed as:

  1. Add `hedwig_brain` to your list of dependencies in `mix.exs`:

    ```elixir
    def deps do
      [{:hedwig_brain, "~> 0.1.0"}]
    end
    ```

  2. Ensure `hedwig_brain` is started before your application:

    ```elixir
    def application do
      [applications: [:hedwig_brain]]
    end
    ```

  3. Specify the brain type in the `config.exs` of your bot

    ```elixir
    config :hedwig_brain, brain_type: HedwigBrain.InMemory.Brain
    ```
  
  4. To use the redis brain, you will also need to add your redis url to the `config.exs` of your bot

    ```elixir
    config :hedwig_brain, redis_url: "redis://localhost:6379/1"
    ```
    

