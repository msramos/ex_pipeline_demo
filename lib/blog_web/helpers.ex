defmodule BlogWeb.Helpers do
  def signed_in?(conn) do
    Plug.Conn.get_session(conn, :user) != nil
  end
end
