defmodule Discuss.Repo.Migrations.AddUsers do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :name, :string
      add :nickname, :string
      add :email, :string
      add :token, :string
      add :provider, :string

      timestamps()
    end
  end
end
