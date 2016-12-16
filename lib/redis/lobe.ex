

defmodule HedwigBrain.Redis.Lobe do
  defstruct [:name, :conn]

  alias HedwigBrain.Redis.Registry

  def new(name) do
    %HedwigBrain.Redis.Lobe{name: name, conn: Registry.get_lobe(name)}        
  end

  def get(lobe, key) do
    case Redix.command(lobe.conn, ~w(HGET #{lobe.name}) ++ [encode(key)]) do
      {:ok, result} -> decode(result)
      _ -> :error
    end 
  end

  def put(lobe, key, value) do
    Redix.command(lobe.conn, ~w(HSET #{lobe.name}) ++ [encode(key)] ++ [encode(value)])
  end

  def delete(lobe, key) do
    Redix.command(lobe.conn, ~w(HDEL #{lobe.name}) ++ [encode(key)])
  end
  
  def delete_all(lobe) do
    case keys(lobe) do
      {:ok, all_keys} when length(all_keys) > 0 ->
        Redix.command(lobe.conn, ~w(HDEL #{lobe.name}) ++ all_keys)
      _ -> :error
    end     
  end

  def all(lobe) do
    case Redix.command(lobe.conn, ~w(HGETALL #{lobe.name})) do
      {:ok, result} ->
        result
        |> Enum.chunk(2)
        |> Enum.map(fn [k, v] -> {decode(k), decode(v)} end)
        |> Enum.into(%{})
         
      _ -> :error
    end        
  end

  def keys(lobe) do
    Redix.command(lobe.conn, ~w(HKEYS #{lobe.name}))
  end

  # so we can use atoms, maps, structs etc.
  defp encode(nil), do: nil
  defp encode(value), do: :erlang.term_to_binary(value)
  defp decode(nil), do: nil
  defp decode(value), do: :erlang.binary_to_term(value)
end
