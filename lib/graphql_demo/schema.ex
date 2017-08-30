defmodule GraphqlDemo.Schema do
  alias GraphqlDemo.Queue

  use Absinthe.Schema
  use Absinthe.Schema.Notation

  @desc "An object representing FIFO queue"
  object :queue do
    @desc "Get full queue content"
    field :inspect, non_null(list_of(:integer)) do
      resolve fn _, _ -> {:ok, Queue.inspect()} end
    end

    @desc "Get next item to be dequeued without actually dequeueing it"
    field :peek, :integer do
      resolve fn _, _ ->
        case Queue.peek() do
          {:ok, _} = res -> res
          :err -> {:error, "Can't peek into an empty queue"}
        end
      end
    end
  end

  @desc "An object representing mutations to FIFO queue"
  object :queue_mutation do
    @desc "Enqueue an item"
    field :enqueue, non_null(:queue) do
      arg :item, :integer, description: "Item to enqueue"
      resolve fn %{item: item}, _ -> {:ok, Queue.enqueue(item)} end
    end

    @desc "Dequeue an item"
    field :dequeue, :integer do
      resolve fn _, _ ->
        case Queue.dequeue() do
          {:ok, _} = res -> res
          :err -> {:error, "Can't dequeue from an empty queue"}
        end
      end
    end

    @desc "Empty the queue"
    field :clear, non_null(:queue) do
      resolve fn _, _ -> {:ok, Queue.clear()} end
    end
  end

  query do
    @desc "Queue query root"
    field :queue, :queue do
      resolve fn _, _ -> {:ok, true} end
    end
  end

  mutation do
    @desc "Queue mutation root"
    field :queue, :queue_mutation do
      resolve fn _, _ -> {:ok, true} end
    end
  end
end
