defmodule PointingParty.PageController do
  use PointingParty.Web, :controller

  plug :name_the_party when not action in [:create]

  def index(conn, _params) do
    render conn, "index.html"
  end

  def new(conn, _params) do
    render conn, "new.html"
  end

  def create(conn, %{"party" => %{"for" => ""}}) do
    conn
    |> put_flash(:info, "Please provide a session name")
    |> redirect(to: page_path(conn, :index))
  end
  def create(conn, %{"party" => %{"for" => party_name}}) do
    conn
    |> put_session(:party_name, party_name)
    |> redirect(to: page_path(conn, :index))
  end

  defp name_the_party(conn, _) do
    if party_name = get_session(conn, :party_name) do
      conn
      |> assign(:party_name, party_name)
      |> assign(:party_token, Phoenix.Token.sign(conn, "user token", party_name))
    else
      conn
      |> render("new.html")
      |> halt()
    end
  end
end
