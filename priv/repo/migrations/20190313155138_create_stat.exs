defmodule BookList.Repo.Migrations.CreateStat do
  use Ecto.Migration

  def change do
    create table(:stats) do
      add :users, :integer
      add :books, :integer
      add :books_read, :integer
      add :pages, :integer
      add :pages_read, :integer

      timestamps()
    end
  end
end
