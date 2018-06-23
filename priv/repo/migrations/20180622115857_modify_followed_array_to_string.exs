defmodule BookList.Repo.Migrations.ModifyFollowedArrayToString do
  use Ecto.Migration

  def change do
    alter table(:users) do
      modify :follow, {:array, :string}, default: [ ]
    end
  end
end
