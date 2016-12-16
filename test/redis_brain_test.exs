defmodule RedisBrainTest do
  use ExUnit.Case

  setup_all do
    {:ok, _} = HedwigBrain.Redis.Brain.start_link([])
    :ok
  end

  setup do
    brain = HedwigBrain.Redis.Brain
    lobe = brain.get_lobe("test_lobe")
    brain.delete_all(lobe)
    %{brain: brain, lobe: lobe}
  end

  # InMemory specific tests

  test "load is a no op", %{brain: brain} do
    assert brain.load == :ok
  end

  test "save is a no op", %{brain: brain} do
    assert brain.save == :ok
  end

  test "stop is a no op", %{brain: brain} do
    assert brain.stop == :ok
  end    

  test "get_lobe returns a Lobe", %{lobe: lobe} do
    assert %HedwigBrain.Redis.Lobe{} = lobe
  end  

  test "a lobe has a pid for a redis connection", %{lobe: lobe} do
    assert is_pid(lobe.conn)
  end

  # Tests that all brain implementations should pass

  test "dump returns all data in the brain", %{brain: brain, lobe: lobe} do    
    brain.put(lobe, :foo, :bar)
    brain.put(lobe, :bar, :baz)
    assert %{"test_lobe" => %{foo: :bar, bar: :baz}} = brain.dump
  end

  test "put and get", %{brain: brain, lobe: lobe} do 
    brain.put(lobe, :foo, :bar)
    assert brain.get(lobe, :foo) == :bar
  end

  test "put and delete", %{brain: brain, lobe: lobe} do 
    brain.put(lobe, :foo, :bar)
    brain.delete(lobe, :foo)
    assert brain.get(lobe, :foo) == nil
  end

  test "delete all", %{brain: brain, lobe: lobe} do 
    brain.put(lobe, :foo, :bar)
    brain.put(lobe, :bar, :baz)    
    brain.delete_all(lobe)
    assert brain.get(lobe, :foo) == nil
    assert brain.get(lobe, :bar) == nil
  end

  test "all", %{brain: brain, lobe: lobe} do
    brain.put(lobe, :foo, :bar)
    brain.put(lobe, :bar, :baz)
    assert Enum.count(brain.all(lobe)) == 2    
  end
end