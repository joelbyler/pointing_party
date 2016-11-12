defmodule PointingParty.PartyChannel do
  use Phoenix.Channel
  alias PointingParty.Presence

  def join("party:" <> party_key, _params, socket) do
    IO.puts "party:#{party_key}"
    party = PointingParty.PartyTracker.party(party_key)
    socket =
      socket
      |> assign(:party, party)
      |> assign(:party_key, party_key)

    send self(), :after_join

    {:ok, %{user_name: socket.assigns.user_name, data: %{}}, socket}
  end

  def handle_info(:after_join, socket) do
    push socket, "presence_state", Presence.list(socket)
    {:ok, ref} = Presence.track(socket, socket.assigns.user_name, %{})
    :ok = PointingParty.Endpoint.subscribe("party:#{socket.assigns.party_key}:#{ref}")

    {:noreply, socket}
  end

  def handle_in("message:new", message, socket) do
    broadcast! socket, "message:new", %{
      user: socket.assigns.user_name,
      body: message,
      timestamp: :os.system_time(:milli_seconds)
    }
    {:noreply, socket}
  end
end
