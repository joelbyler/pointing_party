defmodule PointingPartyWeb.UserSocket do
  use Phoenix.Socket

  ## Channels
  # channel "room:*", PointingPartyWeb.RoomChannel
  channel("party:*", PointingPartyWeb.PartyChannel)

  ## Transports
  transport(:websocket, Phoenix.Transports.WebSocket)

  def connect(%{"token" => token}, socket) do
    case Phoenix.Token.verify(socket, "user name", token, max_age: 1_209_600) do
      {:ok, user_name} ->
        {:ok, assign(socket, :user_name, user_name)}

      {:error, _reason} ->
        :error
    end
  end

  def id(_socket), do: nil
end
