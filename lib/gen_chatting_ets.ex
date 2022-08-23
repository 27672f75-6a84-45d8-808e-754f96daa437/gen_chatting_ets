defmodule GenChattingEts do
  use GenServer

  def start_link(init_arg) do
    room_name = init_arg[:room_name]
    # 서버가 터지고 재시작될 때 이전 정보를 가져옴.
    client_list = GenChattingEts.SimpleCache.get(room_name) |> List.flatten()
    GenServer.start_link(__MODULE__, client_list, name: {:global, room_name})
  end

  def send({room_name, message}) do
    GenServer.cast({:global, room_name}, {:send, message})
  end

  # 서버를 터트리기 위한 임시 함수
  def raise({room_name}) do
    GenServer.cast({:global, room_name}, {:raise})
  end

  @impl true
  def init(init_arg) do
    {:ok, init_arg}
  end

  @impl true
  def handle_call({:connect, client_pid, room_name}, _from, state) do
    client_list = GenChattingEts.SimpleCache.get(room_name) |> List.flatten()
    new_state = Enum.uniq(client_pid ++ state ++ client_list)
    GenChattingEts.SimpleCache.set(room_name, new_state)
    {:reply, client_pid, new_state}
  end

  @impl true
  def handle_cast({:send, message}, state) do
    Enum.map(state, fn client_pid -> send(client_pid, {:message, message}) end)
    {:noreply, state}
  end

  @impl true
  def handle_cast({:raise}, state) do
    send(:a, {:message, "Raise"})
    {:noreply, state}
  end
end
