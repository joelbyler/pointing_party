defmodule PointingParty.JoinController do
  use PointingParty.Web, :controller

  def join(conn, %{"k" => party_key}) do
    conn
    |> join_the_party(party_key)
    |> redirect(to: user_path(conn, :signin))
  end

  defp join_the_party(conn, party_key) do
    party = PointingParty.PartyTracker.party(party_key)
    conn
    |> put_session(:party_name, party.name)
    |> put_session(:party_key, party_key)
  end
end
