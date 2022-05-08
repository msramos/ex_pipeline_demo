defmodule Blog.Schema.User do
  use Ecto.Schema
  import Ecto.Changeset

  schema "users" do
    field :email, :string
    field :password_hash, :string, redact: true
    field :password, :string, redact: true, virtual: true
    field :password_confirmation, :string, redact: true, virtual: true

    timestamps()
  end

  def changeset(%__MODULE__{} = struct, params \\ %{}) do
    struct
    |> cast(params, [:email, :password, :password_confirmation])
    |> validate_required([:email, :password, :password_confirmation])
    |> unique_constraint(:email)
    |> validate_confirmation(:password)
    |> password_hash()
  end

  defp password_hash(%Ecto.Changeset{valid?: true, changes: %{password: password}} = changeset) do
    change(changeset, Argon2.add_hash(password))
  end

  defp password_hash(changeset), do: changeset

  def verify_password(user, password) do
    Argon2.check_pass(user, password)
  end
end
