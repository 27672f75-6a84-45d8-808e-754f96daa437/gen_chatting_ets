defmodule GenChattingEts do
  use GenServer

  def start_link(init_arg) do
    room_name = init_arg[:room_name]
    GenServer.start_link(__MODULE__, room_name, name: {:global, room_name})
  end

  def connect(room_name, client_pid) do
    GenServer.call({:global, room_name}, {:connect, client_pid})
  end

  def send({room_name, message}) do
    GenServer.cast({:global, room_name}, {:send, message})
  end

  @impl true
  def init(room_name) do
    {:ok, room_name}
  end

  @impl true
  def handle_call({:connect, client_pid}, _from, room_name) do
    GenChattingEts.SimpleCache.add(room_name, client_pid)
    {:reply, self(), room_name}
  end

  @impl true
  def handle_cast({:send, message}, room_name) do
    :a = message
    client_list = GenChattingEts.SimpleCache.get(room_name)
    Enum.map(client_list, fn client_pid -> send(client_pid, {:message, message}) end)
    {:noreply, room_name}
  end

  @impl true
  def terminate(reason, room_name) do
    IO.inspect({reason, room_name})
  end
end
