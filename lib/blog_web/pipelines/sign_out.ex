defmodule BlogWeb.Pipelines.SignOut do
  require Logger

  use Pipeline

  pipeline :sign_in do
    step(:clear_session)
    then(:report)
  end

  def clear_session(conn, _) do
    {:ok, Plug.Conn.delete_session(conn, :user)}
  end

  def report(%Pipeline.State{} = state, _options) do
    if state.valid? do
      Logger.info("New user sign-out detected!")
    else
      Logger.warn("Failed sign-out attempt!")
    end
  end
end
