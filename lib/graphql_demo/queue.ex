defmodule GraphqlDemo.Queue do
  use GenServer

  def start_link, do: GenServer.start_link(__MODULE__, nil, name: __MODULE__)

  def init(nil) do
    {:ok, random_list()}
  end

  def handle_call({:enqueue, item}, _from, queue) do
    queue = [item | queue]
    {:reply, queue, queue}
  end
  def handle_call(:dequeue, _from, queue) do
    {item, queue} = List.pop_at(queue, -1)
    return_value = if item, do: {:ok, item}, else: :err
    {:reply, return_value, queue}
  end
  def handle_call(:peek, _from, queue) do
    item = List.last(queue)
    return_value = if item, do: {:ok, item}, else: :err
    {:reply, return_value, queue}
  end
  def handle_call(:inspect, _from, queue) do
    {:reply, queue, queue}
  end
  def handle_call(:clear, _from, queue) do
    {:reply, [], []}
  end

  def enqueue(item), do: GenServer.call(__MODULE__, {:enqueue, item})
  def dequeue(), do: GenServer.call(__MODULE__, :dequeue)
  def peek(), do: GenServer.call(__MODULE__, :peek)
  def inspect(), do: GenServer.call(__MODULE__, :inspect)
  def clear(), do: GenServer.call(__MODULE__, :clear)

  defp random_list do
    fn -> Enum.random(1..100) end
    |> Stream.repeatedly()
    |> Enum.take(Enum.random(5..20))
  end
end
