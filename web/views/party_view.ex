defmodule PointingParty.PartyView do
  use PointingParty.Web, :view

  def build_join_url(key) do
    Application.get_env(:pointing_party, PointingParty.Endpoint)[:url][:scheme] || "http" <>
      "://" <>
      Application.get_env(:pointing_party, PointingParty.Endpoint)[:url][:host]
       <>
      "/#{key}"
  end

end
