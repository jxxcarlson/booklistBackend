defmodule BookList.Repo.Migrations.PagesReadToday do
  use Ecto.Migration

  def change do
    alter table(:books) do
      add :pages_read_today, :integer, default: 0
    end
  end
end
