defmodule PointingParty.PageController do
  use PointingParty.Web, :controller

  plug :name_the_party when not action in [:create]
  plug :name_the_user when not action in [:connect]

  def index(conn, _params) do
    render conn, "index.html"
  end

  def show(conn, _params) do
    render conn, "show.html"
  end

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
    |> put_session(:party_name, party_name)
    |> redirect(to: page_path(conn, :signin))
  end

  def signin(conn, _params) do
    render conn, "signin.html"
  end

  def connect(conn, %{"party" => %{"user_name" => ""}}) do
    conn
    |> put_flash(:info, "Please provide a user name")
    |> redirect(to: page_path(conn, :signin))
  end
  def create(conn, %{"party" => %{"user_name" => user_name}}) do
    IO.puts "user_name: #{user_name}"
    conn
    |> put_session(:user_name, user_name)
    |> redirect(to: page_path(conn, :show))
  end

  defp name_the_party(conn, _) do
    if party_name = get_session(conn, :party_name) do
      conn
      |> assign(:party_name, party_name)
      |> assign(:party_invite_key, party_invite_key)
      |> assign(:party_token, Phoenix.Token.sign(conn, "party token", party_name))
    else
      conn
      |> render("new.html")
      |> halt()
    end
  end

  defp name_the_user(conn, _) do
    if user_name = get_session(conn, :user_name) do
      conn
      |> assign(:user_name, user_name)
    else
      conn
      |> render("signin.html")
      |> halt()
    end
  end

  defp party_invite_key do
    SecureRandom.urlsafe_base64
  end
end
