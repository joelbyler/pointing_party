defmodule PointingPartyWeb.PartyChannel do
  use Phoenix.Channel
  alias PointingPartyWeb.Presence

  def join("party:" <> party_key, _params, socket) do
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
    {:ok, ref} = Presence.track(socket, socket.assigns.user_name, %{
        points: nil
      })
    :ok = PointingPartyWeb.Endpoint.subscribe("party:#{socket.assigns.party_key}:#{ref}")

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

  def handle_in("points:new", %{}, socket) do
    {:ok, _} = Presence.update(socket, socket.assigns.user_name, %{
      points: "0"
    })
    {:noreply, socket}
  end

  def handle_in("points:new", points, socket) do
    {:ok, _} = Presence.update(socket, socket.assigns.user_name, %{
      points: points
    })
    {:noreply, socket}
  end

  def handle_in("points:reset", %{}, socket) do
    broadcast! socket, "user:points:reset", %{}
    {:noreply, socket}
  end

  intercept ["user:points:reset"]

  def handle_out("user:points:reset", msg, socket) do
    {:ok, _} = Presence.update(socket, socket.assigns.user_name, %{
      points: nil
    })
    {:noreply, socket}
  end

  def handle_in("points:show", %{}, socket) do
    broadcast! socket, "user:points:show", %{}
    {:noreply, socket}
  end
end
