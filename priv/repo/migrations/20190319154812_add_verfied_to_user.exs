defmodule BookList.Repo.Migrations.AddVerfiedToUser do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :verified, :boolean, default: false
    end
  end
end
