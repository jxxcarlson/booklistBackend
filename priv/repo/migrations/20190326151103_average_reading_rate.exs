defmodule BookList.Repo.Migrations.AverageReadingRate do
  use Ecto.Migration

  def change do
    alter table(:books) do
      add :average_reading_rate, :integer, default: 0
    end
  end
end
