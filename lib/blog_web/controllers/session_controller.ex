defmodule BlogWeb.SessionController do
  use BlogWeb, :controller

  alias BlogWeb.Pipelines.{SignIn, SignOut}

  def new(conn, _) do
    render(conn, "new.html")
  end

  def create(conn, params) do
    case Pipeline.execute(SignIn, {conn, params}) do
      {:ok, conn} ->
        conn
        |> put_flash(:info, "Welcome!")
        |> redirect(to: Routes.page_path(conn, :index))

      {:error, changeset} ->
        conn
        |> put_flash(:error, "Failed login")
        |> render("new.html", changeset: changeset)
    end
  end

  def delete(conn, params) do
    case Pipeline.execute(SignOut, conn) do
      {:ok, conn} ->
        conn
        |> put_flash(:info, "Bye, bye!")
        |> redirect(to: Routes.page_path(conn, :index))

      {:error, changeset} ->
        conn
        |> put_flash(:error, "Whoops")
        |> render("new.html", changeset: changeset)
    end
  end
end
