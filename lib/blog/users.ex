defmodule Blog.Users do
  alias Blog.Repo
  alias Blog.Schema.User

  import Ecto.Query

  def create(params) do
    %User{}
    |> User.changeset(params)
    |> Repo.insert()
  end

  def by_email(email) do
    query = from u in User, where: u.email == ^email

    Repo.one(query)
  end

  @spec authenticate(any(), any()) :: {:ok, struct()} | :error
  def authenticate(email, password) do
    email
    |> by_email()
    |> User.verify_password(password)
  end
end
