defmodule BlogWeb.Pipelines.SignIn do
  alias Blog.Users

  require Logger

  use Pipeline

  pipeline :sign_in do
    step(:extract_params)
    step(:authenticate)
    step(:start_session)

    then(:report)
  end

  def extract_params({conn, params}, _) do
    case params do
      %{"email" => email, "password" => password} ->
        {:ok,
         %{
           conn: conn,
           credentials: %{
             email: email,
             password: password
           }
         }}

      _ ->
        {:error, "invalid email and/or password"}
    end
  end

  def authenticate(%{conn: conn, credentials: %{email: email, password: password}}, _options) do
    case Users.authenticate(email, password) do
      {:ok, user} ->
        {:ok, %{conn: conn, user: user}}

      _error ->
        {:error, "invalid email and/or password"}
    end
  end

  def start_session(%{conn: conn, user: user}, _options) do
    {:ok, Plug.Conn.put_session(conn, :user, user)}
  end

  def report(%Pipeline.State{} = state, _options) do
    if state.valid? do
      Logger.info("New user login detected!")
    else
      Logger.warn("Failed login attempt!")
    end
  end
end
