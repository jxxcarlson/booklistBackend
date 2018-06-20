defmodule BookList.Repo.Migrations.AddPublicToUser do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :public, :boolean, default: false
    end
  end
end
