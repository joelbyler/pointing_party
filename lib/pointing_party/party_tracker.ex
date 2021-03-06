defmodule Party do
  defstruct party_key: "", name: "", creator_key: "", party_token: ""
end

defmodule PointingParty.PartyTracker do
  use GenServer

  # Client API

  def start_link(opts \\ []) do
    initial_state = [
      ets_table_name: :party_tracker,
      parties: %{}
    ]

    {:ok, _pid} = GenServer.start_link(__MODULE__, initial_state, opts)
  end

  def start_party(name) do
    party_key = generate_party_key(4)
    GenServer.cast(:party_tracker, {:start_party, party_key, name})
    party_key
  end

  def remove(party_key) do
    GenServer.cast(:party_tracker, {:remove, party_key})
  end

  def party(party_key) do
    GenServer.call(:party_tracker, {:party, party_key})
  end

  # Server implementation

  def init(args) do
    [{:ets_table_name, ets_table_name}, {:parties, parties}] = args

    :ets.new(ets_table_name, [:named_table, :set, :private])

    {:ok, %{parties: parties, ets_table_name: ets_table_name}}
  end

  def handle_cast({:start_party, party_key, name}, state) do
    IO.puts("start_party: #{party_key}; #{name}")
    true = :ets.insert(state.ets_table_name, {party_key, %{name: name}})
    {:noreply, state}
  end

  def handle_cast({:remove, party_key}, state) do
    true = :ets.delete(state.ets_table_name, party_key)
    {:noreply, state}
  end

  def handle_cast(_msg, _state) do
    IO.puts("WARNING: default cast in GenServer")
    {:noreply, []}
  end

  def handle_call({:party, party_key}, _from, state) do
    %{ets_table_name: ets_table_name} = state
    result = (:ets.lookup(ets_table_name, party_key) ++ [{party_key, nil}]) |> hd |> map_to_party
    IO.puts("get_party: #{party_key}; #{result.name}")
    {:reply, result, state}
  end

  def handle_call(_msg, _from, _state) do
    IO.puts("WARNING: default call in GenServer")
    {:reply, :ok, []}
  end

  def stop(server) do
    GenServer.call(server, :stop)
  end

  defp map_to_party({party_key, nil}) do
    %Party{party_key: party_key}
  end

  defp map_to_party(party) do
    struct(%Party{party_key: hd(Tuple.to_list(party))}, hd(tl(Tuple.to_list(party))))
  end

  defp generate_party_key(key_length) do
    key_length
    |> :crypto.strong_rand_bytes()
    |> Base.url_encode64()
    |> binary_part(0, key_length)
    |> String.upcase()
  end
end
