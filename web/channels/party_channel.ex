defmodule PointingParty.PartyChannel do
  use Phoenix.Channel
  alias PointingParty.Presence

  def join("party:" <> token, _params, socket) do
    # {:ok, party} = Party.find(token)
    party = "foo"
    socket =
      socket
      |> assign(:party, party)
      |> assign(:party_token, token)

    send self(), :after_join

    {:ok, %{user_name: socket.assigns.user_name, data: %{}}, socket}
  end

  def handle_info(:after_join, socket) do
    push socket, "presence_state", Presence.list(socket)
    {:ok, ref} = Presence.track(socket, socket.assigns.user_name, %{})
    :ok = PointingParty.Endpoint.subscribe("party:#{socket.assigns.party_token}:#{ref}")

    {:noreply, socket}
  end
end
