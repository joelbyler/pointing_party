defmodule PointingParty.PartyController do
  use PointingParty.Web, :controller

  plug :require_party when not action in [:create]
  plug :require_user when action in [:show]

  def new(conn, _params) do
    render conn, "new.html"
  end

  def create(conn, %{"party" => %{"for" => ""}}) do
    conn
    |> put_flash(:info, "Please provide a session name")
    |> redirect(to: page_path(conn, :new))
  end
  def create(conn, %{"party" => %{"for" => party_name}}) do
    conn
    |> start_party_tracker(party_name)
    |> put_session(:party_name, party_name)
    |> redirect(to: user_path(conn, :signin))
  end

  def show(conn, _params) do
    conn
    |> assign(:party_key, get_session(conn, :party_key))
    |> assign(:party_name, get_session(conn, :party_name))
    |> assign(:user_name, get_session(conn, :user_name))
    |> render("show.html")
  end

  defp start_party_tracker(conn, party_name) do
    party_key = SecureRandom.urlsafe_base64
    PointingParty.PartyTracker.start_party(party_key, party_name)

    conn
    |> put_session(:party_key, party_key)
  end

  defp require_party(conn, _) do
    if party_key = get_session(conn, :party_key) do
      conn
      |> assign(:party_key, party_key)
      |> assign(:party_token, Phoenix.Token.sign(conn, "party token", party_key))
    else
      conn
      |> render("new.html")
      |> halt()
    end
  end
  defp require_user(conn, _) do
    if user_name = get_session(conn, :user_name) do
      conn
      |> assign(:user_name, user_name)
      |> assign(:user_token, Phoenix.Token.sign(conn, "user name", user_name))
    else
      conn
      |> render("signin.html")
      |> halt()
    end
  end
end
