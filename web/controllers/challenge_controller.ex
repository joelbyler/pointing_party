defmodule PointingParty.ChallengeController do
  use PointingParty.Web, :controller

  plug :put_layout, false
  @input_sha Application.get_env(:pointing_party, :ssl_config)[:input_sha]
  @output_sha Application.get_env(:pointing_party, :ssl_config)[:output_sha]

  def show(conn, %{ "id" => @input_sha }) do
    render conn, "show.html", sha: @output_sha
  end

  def show(conn, %{ "id" => bad_sha }) do
    render conn, "show.html", sha: "bad_sha: #{bad_sha}, should be #{@input_sha}"
  end
end
