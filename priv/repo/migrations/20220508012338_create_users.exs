defmodule Blog.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table("users") do
      add :email, :string, size: 63, null: false
      add :password_hash, :string
      timestamps()
    end

    unique_index("users", [:email])
  end
end
