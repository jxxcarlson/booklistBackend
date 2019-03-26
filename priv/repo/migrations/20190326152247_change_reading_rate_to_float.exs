defmodule BookList.Repo.Migrations.ChangeReadingRateToFloat do
  use Ecto.Migration

  def change do
    alter table(:books) do
      modify :average_reading_rate, :float, default: 0
    end
  end
end
