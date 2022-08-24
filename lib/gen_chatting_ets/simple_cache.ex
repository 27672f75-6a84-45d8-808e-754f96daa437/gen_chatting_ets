defmodule GenChattingEts.SimpleCache do
  use GenServer

  def start_link(_init_arg) do
    GenServer.start_link(__MODULE__, [], name: __MODULE__)
  end

  @impl true
  def init(_init_arg) do
    table = :ets.new(__MODULE__, [:set, :public])
    {:ok, table}
  end

  def get(room_name) do
    GenServer.call(__MODULE__, {:get, room_name})
  end

  def add(room_name, client) do
    GenServer.call(__MODULE__, {:add, room_name, client})
  end

  @impl true
  def handle_call({:get, room_name}, _from, table) do
    client_list = get_client_list(table, room_name)
    {:reply, client_list, table}
  end

  @impl true
  def handle_call({:add, room_name, client}, _from, table) do
    client_list = get_client_list(table, room_name)
    :ets.insert(table, {room_name, [client | client_list]})
    {:reply, :ok, table}
  end

  defp get_client_list(table, room_name) do
    case :ets.lookup(table, room_name) do
      [] -> []
      [{^room_name, client_list}] -> client_list
    end
  end
end
