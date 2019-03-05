defmodule BookList.Repo.Migrations.Groups do
  use Ecto.Migration

  def change do
    create table(:groups) do
      add :firstName, :string
      add :chair, :string
      add :cochair, :string
      add :blurb, :string
      add :members, {:array, :string}

      timestamps()
    end
end
