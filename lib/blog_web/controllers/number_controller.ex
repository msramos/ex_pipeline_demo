defmodule BlogWeb.NumberController do
  use BlogWeb, :controller

  alias Blog.Pipeline.ParseNumber

  def show(conn, %{"number" => number}) do
    case Pipeline.execute(ParseNumber, number) do
      {:ok, value} ->
        conn
        |> put_flash(:info, "Success!")
        |> render("show_success.html", number: value)

      {:error, message} ->
        conn
        |> put_flash(:error, "Error!")
        |> render("show_error.html", message: message)
    end
  end
end
