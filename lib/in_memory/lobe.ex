defmodule HedwigBrain.InMemory.Lobe do
  @doc """
  Starts a new `lobe`.
  """
  def start_link do
    Agent.start_link(fn -> Map.new end)
  end

  @doc """
  Retrieves a value from the `lobe`.
  """
  def get(lobe, key) do
    Agent.get(lobe, &Map.get(&1, key))
  end

  @doc """
  Puts a value in the `lobe`
  """
  def put(lobe, key, value) do
    Agent.update(lobe, &Map.put(&1, key, value))
  end


  @doc """
  Deletes an item from the `lobe`
  """
  def delete(lobe, key) do
    Agent.get_and_update(lobe, &Map.pop(&1, key))
  end


  @doc """
  Deletes all items from the `lobe`
  """
  def delete_all(lobe) do
    Agent.update(lobe, fn _ -> %{} end)
  end

  @doc """
  Returns all the items in the `lobe`
  """
  def all(lobe) do
    Agent.get(lobe, &(&1))
  end
end