defmodule PointingPartyWeb.UserController do
  use PointingPartyWeb, :controller

  plug :require_party when not action in [:connect]
  plug :require_user when not action in [:connect]

  def signin(conn, _params) do
    render conn, "signin.html"
  end

  def connect(conn, %{"party" => %{"user_name" => ""}}) do
    conn
    |> put_flash(:info, "Please provide a user name")
    |> redirect(to: page_path(conn, :signin))
  end
  def connect(conn, %{"party" => %{"user_name" => user_name}}) do
    conn
    |> put_session(:user_name, user_name)
    |> redirect(to: party_path(conn, :show))
  end

  defp require_party(conn, _) do
    if party_key = get_session(conn, :party_key) do
      conn
      |> assign(:party_key, party_key)
      |> assign(:party_token, Phoenix.Token.sign(conn, "party token", party_key))
    else
      conn
      |> redirect(to: party_path(conn, :new))
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
