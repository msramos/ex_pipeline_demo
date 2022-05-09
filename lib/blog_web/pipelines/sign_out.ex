defmodule BlogWeb.Pipelines.SignOut do
  require Logger

  use Pipeline

  pipeline :sign_in do
    step(:clear_session)
    then(:report)
  end

  def clear_session(conn, _) do
    {:ok, Plug.Conn.clear_session(conn)}
  end

  def report(_state, _options) do
    Logger.info("New user sign-out detected!")
  end
end
