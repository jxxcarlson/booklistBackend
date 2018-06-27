defmodule BookList.Repo.Migrations.AddFollowersToUser do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :followers, {:array, :string}, default: [ ]
    end
  end
end
