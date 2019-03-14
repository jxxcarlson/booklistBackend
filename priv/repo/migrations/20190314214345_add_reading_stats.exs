defmodule BookList.Repo.Migrations.AddReadingStats do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :reading_stats, {:array, :jsonb}, default: [ ]
    end
  end
end
