defmodule BookList.Repo.Migrations.ModifyFollowedArray do
  use Ecto.Migration

  def change do
    alter table(:users) do
      modify :follow, {:array, :integer}, default: [ ]
    end
  end
end
